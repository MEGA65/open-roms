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
    
    d=opendir(directory);
    if (!d) DO_ERROR("opendir() failed");

    while((de=readdir(d))!=NULL) {
      if (strlen(de->d_name)>2) {
	if (!strcmp(&de->d_name[strlen(de->d_name)-2],".s")) {
	  printf("%s\n",de->d_name);
	}
      }
    }
    
  } while(0);

  if (d) closedir(d);
  return retVal;
}
