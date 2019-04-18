/*
  Pre-process the various assembly source files to create a single
  file for assembly, that has everything where it needs to live.

*/

#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define DO_ERROR(X) { retVal=-1; fprintf(stderr,"%s:%d:%s():%s\n",__FILE__,__LINE__,__func__,X); break; }

#define MAX_FILES (128*1024)
typedef struct source_file {
  char *file;
  int address;

  // For getting routine sizes from first run of ophis
  int low_addr;
  int high_addr;
  int size;
} source_file;

source_file source_files[MAX_FILES];
int source_count=0;

static int compare_source(const void* a, const void* b)
{
  source_file* aa = (source_file*)a;
  source_file* bb = (source_file*)b;
  
  if (aa->address<bb->address) return -1;
  if (aa->address>bb->address) return 1;
  return strcmp(aa->file,bb->file);
}

int dump_file(FILE *out,const char *name)
{
  int retVal=0;
  FILE *f=NULL;
  
  do {
    f=fopen(name,"r");
    if (!f) DO_ERROR("Failed to read file for input");
    char line[8192];
    while(!feof(f)) {
      line[0]=0; fgets(line,8192,f);
      fprintf(out,"%s",line);
    }
  } while(0);

  if (f) fclose(f);
  return retVal;
}

void usage(void)
{
  fprintf(stderr,"usage: preprocess [-d <directory>]\n");
  
}

int main(int argc,char **argv)
{

  int retVal=0;
  DIR *d=NULL;
  char *directory=".";
  struct dirent *de=NULL;
  
  do {
    
    int opt;

    while ((opt=getopt(argc,argv,"d:")) != -1) {
      switch(opt) {
      case 'd': directory=optarg; break;
      default:
	usage();
	exit(-1);
      }
    }

    // Get list of files
    d=opendir(directory);
    if (!d) DO_ERROR("opendir() failed");
    while((de=readdir(d))!=NULL) {
      if (strlen(de->d_name)>2) {
	if (!strcmp(&de->d_name[strlen(de->d_name)-2],".s")) {
	  if (source_count>=MAX_FILES) DO_ERROR("Too many source files. Increase MAX_FILES?");
	  source_files[source_count].file=strdup(de->d_name);
	  source_files[source_count].address=-1;
	  source_count++;
	}
      }
    }
    if (retVal) break;
    closedir(d); d=NULL;

    fprintf(stderr,"Found %d source files\n",source_count);

    // Now get routine addresses of everything
    for(int i=0;i<source_count;i++) {
      u_int32_t addr;
      char funcname[1024];
      if (sscanf(source_files[i].file,"%x.%[^.]",&addr,funcname)==2) {
	// Function must appear at specific address
	source_files[i].address=addr;
      }
    }

    fprintf(stderr,"Got fixed routine addresses\n");
    
    // Sort files into order.
    // The sorted order is the order the files will appear in the combined source file.
    // This means that address prefixes on names will be in the right order, but function
    // names will not.
    qsort(source_files,source_count,sizeof(source_file),compare_source);

    fprintf(stderr,"Sorted.\n");
    
    for(int i=0;i<source_count;i++) {
      fprintf(stderr,"$%04X : %s\n",
	      source_files[i].address!=0x7ffffff?source_files[i].address:0,
	      source_files[i].file);
    }

    // First pass is to work out the size of each routine, so that we can pack them optimally
    // around the routines that are located at fixed addresses.
    unlink("temp.map");
    unlink("temp.s");
    FILE *out=fopen("temp.s","w");
    if (!out) DO_ERROR("Could not write to temp.s");
    fprintf(out,"\t.org 0\n");
    for(int i=0;i<source_count;i++) {
      fprintf(out,"; Source file '%s'\n",source_files[i].file);
      fprintf(out,"__routine_start_%s:\n",source_files[i].file);
      char path[8192];
      snprintf(path,8192,"%s/%s",directory,source_files[i].file);
      if (dump_file(out,path)) DO_ERROR("Could not read source file");
      fprintf(out,"__routine_end_%s:\n",source_files[i].file);
    }
    fclose(out);
    char cmd[8192];
    snprintf(cmd,8192,"Ophis/bin/ophis temp.s -m temp.map");
    fprintf(stderr,"Running first pass to get size of routines...\n");
    system(cmd);

    // Parse temp.map contents to get size of every routine
    fprintf(stderr,"Reading sizes of routines...\n");
    out=fopen("temp.map","r");
    if (!out) DO_ERROR("Could not open temp.map for reading. Did Ophis fail due to an error in one of the assembly files?");
    while(!feof(out)) {
      int addr;
      char routine[8192];
      char line[8192];
      line[0]=0; fgets(line,8192,out);
      if (sscanf(line,"$%x __routine_start_%[^ \n]",&addr,routine)==2) {
	for(int i=0;i<source_count;i++)
	  if (!strcmp(routine,source_files[i].file))
	    { source_files[i].low_addr=addr;
	      source_files[i].size=source_files[i].high_addr-source_files[i].low_addr;
	      break; }
      }
      if (sscanf(line,"$%x __routine_end_%[^ \n]",&addr,routine)==2) {
	for(int i=0;i<source_count;i++)
	  if (!strcmp(routine,source_files[i].file))
	    { source_files[i].high_addr=addr;
	      source_files[i].size=source_files[i].high_addr-source_files[i].low_addr;
	      break; }
      }
    }
    fclose(out);

    for(int i=0;i<source_count;i++)
      fprintf(stderr,"%s : %d bytes\n",source_files[i].file,source_files[i].size);
    
    if (retVal) break;
    
  } while(0);

  if (d) closedir(d);
  return retVal;
}
