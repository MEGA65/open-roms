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
  char *label;
  int address;

  // For getting routine sizes from first run of KickAss
  int low_addr;
  int high_addr;
  int size;

  // For knowing when we have output the various routines
  int written;
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
  fprintf(stderr,"usage: preprocess [-d <directory>] [-l <start/low address>] [-h <end/high address>]\n");
  
}

int main(int argc,char **argv)
{

  int retVal=0;
  DIR *d=NULL;
  char *directory=".";
  struct dirent *de=NULL;

  int start_address=0xe4d3;
  int end_address=0xffff+1;
  
  do {
    
    int opt;

    while ((opt=getopt(argc,argv,"d:l:h:")) != -1) {
      switch(opt) {
      case 'd': directory=optarg; break;
      case 'l': start_address=strtol(optarg,NULL,16); break;
      case 'h': end_address=strtol(optarg,NULL,16)+1; break;
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
	      if (de->d_name[0]!='.'&&de->d_name[0]!='#') // ignore temp files etc
	        if (!strcmp(&de->d_name[strlen(de->d_name)-2],".s")) {
	          if (strcmp(de->d_name,"combined.s")) {
	            if (source_count>=MAX_FILES) DO_ERROR("Too many source files. Increase MAX_FILES?");
	            source_files[source_count].file=strdup(de->d_name);
              source_files[source_count].label=strdup(de->d_name);
              for (char *charptr = source_files[source_count].label; *charptr != 0; charptr++) {
                if (*charptr == '.') *charptr = '_'; // KickAss does not like full stops in labels
              }
	            source_files[source_count].address=-1;
	            source_count++;
	          }
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
	// printf("function '%s' should be placed at $%04X\n",funcname,addr);
      }
    }

    fprintf(stderr,"Got fixed routine addresses\n");
    
    // Sort files into order.
    // The sorted order is the order the files will appear in the combined source file.
    // This means that address prefixes on names will be in the right order, but function
    // names will not.
    qsort(source_files,source_count,sizeof(source_file),compare_source);

    fprintf(stderr,"Sorted.\n");
    
    // for(int i=0;i<source_count;i++) {
    //   fprintf(stderr,"$%04X : %s\n",
	  //     source_files[i].address!=0x7ffffff?source_files[i].address:0,
	  //     source_files[i].file);
    // }

    // First pass is to work out the size of each routine, so that we can pack them optimally
    // around the routines that are located at fixed addresses.
    unlink("temp.sym");
    unlink("temp.s");
    FILE *out=fopen("temp.s","w");
    if (!out) DO_ERROR("Could not write to temp.s");
    // Start at $100, so that no local data gets accesses using ZP addressing modes during this pass,
    // which would otherwise upset things later
    fprintf(out,"\t* = $100\n");
    for(int i=0;i<source_count;i++) {
      fprintf(out,"// Source file '%s'\n",source_files[i].file);
      if (source_files[i].file[0]!=',') fprintf(out,"__routine_start_%s:\n",source_files[i].label);
      char path[8192];
      snprintf(path,8192,"%s/%s",directory,source_files[i].file);
      if (dump_file(out,path)) DO_ERROR("Could not read source file");
      if (source_files[i].file[0]!=',') fprintf(out,"__routine_end_%s:\n",source_files[i].label);
    }
    fclose(out);
    char cmd[8192];
    snprintf(cmd,8192,"java -jar assembler/KickAss.jar temp.s -symbolfile -o /dev/null");
    fprintf(stderr,"Running first pass to get size of routines...\n");
    system(cmd);

    // Parse temp.sym contents to get size of every routine
    fprintf(stderr,"Reading sizes of routines...\n");
    out=fopen("temp.sym","r");
    if (!out) DO_ERROR("Could not open temp.sym for reading. Did KickAss fail due to an error in one of the assembly files?");
    while(!feof(out)) {
      int addr;
      char label[8192];
      char line[8192];
      line[0]=0; fgets(line,8192,out);
      if (sscanf(line,".label __routine_start_%[^=]=$%x",label,&addr)==2) {
	for(int i=0;i<source_count;i++)
	  if (!strcmp(label,source_files[i].label))
	    { source_files[i].low_addr=addr;
	      source_files[i].size=source_files[i].high_addr-source_files[i].low_addr;
	      break; }
      }
      if (sscanf(line,".label __routine_end_%[^=]=$%x",label,&addr)==2) {
	for(int i=0;i<source_count;i++)
	  if (!strcmp(label,source_files[i].label))
	    { source_files[i].high_addr=addr;
	      source_files[i].size=source_files[i].high_addr-source_files[i].low_addr;
	      break; }
      }
    }
    fclose(out);

    fprintf(stderr,"Got routine sizes:\n");
    for(int i=0;i<source_count;i++)
      fprintf(stderr,"%s : %d bytes\n",source_files[i].file,source_files[i].size);

    // Now write the routines out in a deterministic order that respects the requirement
    // of some routines to be at fixed addresses.

    // Start at beginning of actual kernal data
    int address=start_address;

    char filename[8192];
    snprintf(filename,8192,"%s/combined.s",directory);
    unlink(filename);
    out=fopen(filename,"w");
    if (!out) DO_ERROR("Could not write to combined.s");

    fprintf(out,"\t.segment Main [start=$%04x, min=$%04x, max=$%04x, outBin=\"OUT.BIN\", fill]\n" ,
            start_address, start_address, end_address - 1);
    fprintf(out,"\t* = $%04x\n",address);

    // First write files of length 0, so that all the zeropage location definitions are
    // known to KickAss - otherwise it will assume 16-bit address is needed, which will backfire
    int written_count = 0;
    for(int i=0;i<source_count;i++) {
      if (source_files[i].size == 0) {
        fprintf(out,"\n// Source file %s\n",source_files[i].file);
        char filename[8192];
        snprintf(filename,8192,"%s/%s",directory,source_files[i].file);
        if (dump_file(out,filename)) DO_ERROR("Could not dump 0-size routine");
        source_files[i].written=1;
      }
      else source_files[i].written=0;
    }
    // XXX - We should use dynamic programming optimisation to pack the routines
    // optimally in the space, so that when we get near to full, we don't run out
    // of space due to fragmentation.
    for(;written_count<source_count;written_count++) {
      // First, find the next allocated address
      int next_allocated_address=0xffff;
      int next_fixed_routine=-1;
      for(int i=0;i<source_count;i++)
	if (!source_files[i].written) {
	  if (source_files[i].address>=address)
	    if (source_files[i].address<next_allocated_address) {
	      next_allocated_address=source_files[i].address;
	      next_fixed_routine=i;
	    }
	}
      int space=next_allocated_address-address;

      int biggest=-1;
      int biggest_size=-1;
      for(int i=0;i<source_count;i++)
	if (!source_files[i].written) {
	  if (source_files[i].address==-1) {
	    if (source_files[i].size>biggest_size) {
	      if (source_files[i].size<=space) {
		biggest_size=source_files[i].size;
		biggest=i;
	      }
	    }
	  }
	}

      // Check if done
      if (next_fixed_routine==-1&&biggest==-1) break;
      
      fprintf(stderr,"At address $%04x, next allocated address is $%04X. Current space is %d bytes\n",
	      address,next_allocated_address,space);
      if (biggest>-1)
	fprintf(stderr,"Biggest floating routine that fits is '%s' (%d bytes)\n",
		source_files[biggest].file,biggest_size);
      if (biggest==-1) {
	// Nothing else fits here.  So write next_fixed_routine
	// fprintf(stderr,"Writing file %s\n",source_files[next_fixed_routine].file);
	fprintf(out,"\n// Source file %s @ $%04X\n",source_files[next_fixed_routine].file,address);
  fprintf(out,"\t* = $%04x\n", next_allocated_address);
	char filename[8192];
	snprintf(filename,8192,"%s/%s",directory,source_files[next_fixed_routine].file);
	if (dump_file(out,filename)) DO_ERROR("Could not dump fixed address routine");
	source_files[next_fixed_routine].written=1;
	address=next_allocated_address+source_files[next_fixed_routine].size;
      } else {
	fprintf(out,"\n// Source file %s @ $%04x\n",source_files[biggest].file,address);
	// fprintf(stderr,"Writing file %s\n",source_files[biggest].file);
  fprintf(out,"\t* = $%04x\n", address);
		
	char filename[8192];
	snprintf(filename,8192,"%s/%s",directory,source_files[biggest].file);
	if (dump_file(out,filename)) DO_ERROR("Could not dump floating routine");
	source_files[biggest].written=1;
	address+=source_files[biggest].size;
      }
    }
    
    fclose(out);
    
    if (retVal) break;

    for(int i=0;i<source_count;i++)
      if (!source_files[i].written) {
	fprintf(stderr,"ERROR: Did not write source file '%s'\n",source_files[i].file);
	DO_ERROR("Did not write all source files.  Did they not fit?");
      }
    if (retVal) break;

    fprintf(stderr,"Assembling combined source...\n");
    snprintf(cmd,8192,"java -jar assembler/KickAss.jar %s/combined.s -symbolfile -vicesymbols -binfile -o %s/OUT.BIN",directory,directory);
    system(cmd);
    
  } while(0);

  if (d) closedir(d);
  return retVal;
}
