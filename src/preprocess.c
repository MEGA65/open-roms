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
  u_int32_t address;
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
	  source_files[source_count].address=0x7fffffff;
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
      printf("$%04X : %s\n",
	     source_files[i].address!=0x7ffffff?source_files[i].address:0,
	     source_files[i].file);
    }
    
  } while(0);

  if (d) closedir(d);
  return retVal;
}
