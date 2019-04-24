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

#define MAX_SIZE 65536
int matches[MAX_SIZE];

int phase_mask[MAX_SIZE+MAX_SIZE];

int main(int argc,char **argv)
{
  if (argc!=3) {
    fprintf(stderr,"usage: similarity <file1> <file2>\n");
    exit(-1);
  }

  for(int i=0;i<MAX_SIZE;i++) matches[i]=0;
  bzero(phase_mask,sizeof(phase_mask));
  
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

      int phase=s2+i-j;

      if (phase<0) {
	fprintf(stderr,"Phase < 0 : %04x %04x -> %d\n",i,j,phase);
	exit(-1);
      }

      if (phase>=(MAX_SIZE+MAX_SIZE)) {
	fprintf(stderr,"Phase too large : %04x %04x -> %d\n",i,j,phase);
	exit(-1);
      }
      
      if (phase_mask[phase]) {
	phase_mask[phase]--;
	continue;
      }
      
      for(k=0;((i+k)<s1)&&((j+k)<s2);k++)
	if (f1[i+k]!=f2[j+k]) break;
      // Ignore matches that are all the same byte
      for(l=1;l<k;l++) if (f1[i+l]!=f1[i]) break;
      if (l<k) {
	// Ignore matches of no more than 3 bytes,
	// since that is the max length of a 6502 instruction
	if (k>2) {
	  matches[k]++;
	}
	if (k>3) {
	  // Display particularly long matches
	  printf("$%04X = $%04X :",i,j);
	  for(int b=0;b<k;b++) printf(" %02X",f1[i+b]);
	  printf("\n");
	}
      }

      // When we find a match, we should then mask off this region,
      // so that we don't find all the sub-sets of the matches.
      // e.g. matching BASIC at $100 will result in a match of ASIC at $101
      // and SIC at $102 etc.  These are all the same match, so should be
      // suppressed.
      phase_mask[phase]=k;
    }
  }

  for(int i=0;i<MAX_SIZE;i++) {
    if (matches[i])
      printf("%6d matches of %d bytes\n",matches[i],i);
  }
  
  return 0;
}
