/*
  Simple program to find matching strings between two binaries
  and report on the statistics of their lengths, and show the
  longer ones. Used to defend against copyright infringement
  claims.
*/

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

#define MAX_SIZE 8192
int matches[MAX_SIZE];

int main(int argc,char **argv)
{
  if (argc!=3) {
    fprintf(stderr,"usage: similarity <file1> <file2>\n");
    exit(-1);
  }

  for(int i=0;i<MAX_SIZE;i++) matches[i]=0;

  unsigned char *f1,*f2;
  int s1,s2;
  struct stat st;
  int fd;

  fd = open(argv[1], O_RDONLY, 0);
  if (fd==-1) {
    fprintf(stderr,"Could not read '%s'\n",argv[1]);
    exit(-1);
  }
  stat(argv[1], &st);
  s1=st.st_size;
  f1 = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE | MAP_POPULATE, fd, 0);
  if (f1== MAP_FAILED) {
    fprintf(stderr,"Could not mmap '%s'\n",argv[1]);
    exit(-1);
  }
  fd = open(argv[2], O_RDONLY, 0);
  if (fd==-1) {
    fprintf(stderr,"Could not read '%s'\n",argv[2]);
    exit(-1);
  }
  stat(argv[2], &st);
  s2=st.st_size;
  f2 = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE | MAP_POPULATE, fd, 0);
  if (f2 == MAP_FAILED) {
    fprintf(stderr,"Could not mmap '%s'\n",argv[2]);
    exit(-1);
  }

  fprintf(stderr,"Searching files for similarities...\n");
  
  for(int i=0;i<s1;i++) {
    for(int j=0;j<s2;j++) {
      int k,l;
      for(k=0;((i+k)<s1)&&((j+k)<s2);k++)
	if (f1[i+k]!=f2[j+k]) break;
      // Ignore matches that are all the same byte
      for(l=1;l<k;l++) if (f1[i+l]!=f1[i]) break;
      if (l<k) {
	if (k) matches[k]++;
      }
     
    }
  }

  for(int i=0;i<MAX_SIZE;i++) {
    if (matches[i])
      printf("%6d matches of %d bytes\n",matches[i],i);
  }
  
  return 0;
}
