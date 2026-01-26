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

#define NUM_CHUNKS 1
// Pairs of start, end memory addresses of known exact similarity with the open source Microsoft BASIC
unsigned short microsoft_basic_chunks[NUM_CHUNKS * 2] = {
    0xBBFC, 0xBC1A,
    0xBC58, 0xBC5A,
};


int main(int argc,char **argv)
{
  int verbose=0;
  int basic = 0;

  if (argc<3) {
    fprintf(stderr,"usage: similarity <file1> <file2> [--verbose] [--basic]\n");
    exit(-1);
  }
  if (argc >= 4) {
    for (int i = 3; i < argc; i++) {
      if (!strcmp(argv[i], "--verbose")) {
        verbose = 1;
      } else if (!strcmp(argv[i], "--basic")) {
        basic = 1;
      } else {
        fprintf(stderr, "Unrecognised directive.\n");
        exit(-1);
      }
    }
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
  f1 = mmap(NULL, st.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_POPULATE, fd, 0);
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

  if (basic) {
    for (int i = 0; i < NUM_CHUNKS; i++) {
      for (int addr = microsoft_basic_chunks[i * 2]; addr <= microsoft_basic_chunks[i * 2 + 1]; addr++) {
        f1[addr - 0xA000] = 0;
      }
    }
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

      // When we find a match, we should then mask off this region,
      // so that we don't find all the sub-sets of the matches.
      // e.g. matching BASIC at $100 will result in a match of ASIC at $101
      // and SIC at $102 etc.  These are all the same match, so should be
      // suppressed.
      phase_mask[phase]=k;
      
      // Ignore matches that are all the same byte
      for(l=1;l<k;l++) if (f1[i+l]!=f1[i]) break;
      if (l<k) {
	// Ignore matches of no more than 3 bytes,
	// since that is the max length of a 6502 instruction
	int single_instruction=0;
	if (k==5) {
	  if (f1[i]==0xa9&&f1[i+2]==0x8d) break; // LDA #$xx / STA $nnnn
	}
	if (k==4) {
	  if (f1[i]==0xa9&&f1[i+2]==0x85) break; // LDA #$xx / STA $nn
	}
	if (k==3) {
	  // Reject some very common instruction fragments


	  // Branch followed by any opcode
	  if (f1[i]==0xd0) break;
	  if (f1[i]==0xf0) break;
	  if (f1[i]==0xb0) break;
	  if (f1[i]==0x90) break;
	  if (f1[i]==0x10) break;
	  // Any single byte followed by a branch
	  if (f1[i+1]==0xd0) break;
	  if (f1[i+1]==0xf0) break;
	  if (f1[i+1]==0xb0) break;
	  if (f1[i+1]==0x90) break;
	  if (f1[i+1]==0x10) break;
	  // Any 2-byte opcode followed by a branch
	  if (f1[i+2]==0xd0) break;
	  if (f1[i+2]==0xf0) break;
	  if (f1[i+2]==0xb0) break;
	  if (f1[i+2]==0x90) break;
	  if (f1[i+2]==0x10) break;

	  
	  // Common 2-byte instructions followed by
	  // any single byte are very common and not
	  // copyrightable.
	  if (f1[i]==0x85) break;
	  if (f1[i]==0xa2) break; // LDX #$xx
	  if (f1[i]==0xa9) break; // LDA #$xx
	  if (f1[i]==0xa5) break; // LDA $xx
	  if (f1[i]==0xa0) break; // LDY #$xx
	  if (f1[i]==0x69) break; // ORA #$xx ?
	  if (f1[i]==0xc9) break; // CMP #$xx
	  if (f1[i]==0x91) break; // STA ($nn),Y
	  // Similarly for random byte before such instructions
	  if (f1[i+1]==0x85) break;
	  if (f1[i+1]==0xa9) break; // LDA #$xx
	  if (f1[i+1]==0xa2) break; // LDX $xx
	  if (f1[i+1]==0xa5) break; // LDA $xx
	  if (f1[i+1]==0xa0) break; // LDY #$xx
	  if (f1[i+1]==0x69) break; // ADC #$xx
	  if (f1[i+1]==0xc9) break; // CMP #$xx
	  
	  // Filter out all 3 byte instructions
	  switch(f1[i]) {
	  case 0x0C: //   TSB $nnnn
	  case 0x0D: //   ORA $nnnn
	  case 0x0E: //   ASL $nnnn
	  case 0x19: //   ORA $nnnn,Y
	  case 0x1C: //   TRB $nnnn
	  case 0x1D: //   ORA $nnnn,X
	  case 0x1E: //   ASL $nnnn,X
	  case 0x20: //   JSR $nnnn
	  case 0x22: //   JSR ($nnnn)
	  case 0x23: //   JSR ($nnnn,X)
	  case 0x2C: //   BIT $nnnn
	  case 0x2D: //   AND $nnnn
	  case 0x2E: //   ROL $nnnn
	  case 0x39: //   AND $nnnn,Y
	  case 0x3C: //   BIT $nnnn,X
	  case 0x3D: //   AND $nnnn,X
	  case 0x3E: //   ROL $nnnn,X
	  case 0x4C: //   JMP $nnnn
	  case 0x4D: //   EOR $nnnn
	  case 0x4E: //   LSR $nnnn
	  case 0x59: //   EOR $nnnn,Y
	  case 0x5D: //   EOR $nnnn,X
	  case 0x5E: //   LSR $nnnn,X
	  case 0x6C: //   JMP ($nnnn)
	  case 0x6D: //   ADC $nnnn
	  case 0x6E: //   ROR $nnnn
	  case 0x79: //   ADC $nnnn,Y
	  case 0x7C: //   JMP ($nnnn,X)
	  case 0x7D: //   ADC $nnnn,X
	  case 0x7E: //   ROR $nnnn,X
	  case 0x8B: //   STY $nnnn,X
	  case 0x8C: //   STY $nnnn
	  case 0x8D: //   STA $nnnn
	  case 0x8E: //   STX $nnnn
	  case 0x99: //   STA $nnnn,Y
	  case 0x9B: //   STX $nnnn,Y
	  case 0x9C: //   STZ $nnnn
	  case 0x9D: //   STA $nnnn,X
	  case 0x9E: //   STZ $nnnn,X
	  case 0xAB: //   LDZ $nnnn
	  case 0xAC: //   LDY $nnnn
	  case 0xAD: //   LDA $nnnn
	  case 0xAE: //   LDX $nnnn
	  case 0xB9: //   LDA $nnnn,Y
	  case 0xBB: //   LDZ $nnnn,X
	  case 0xBC: //   LDY $nnnn,X
	  case 0xBD: //   LDA $nnnn,X
	  case 0xBE: //   LDX $nnnn,Y
	  case 0xCB: //   ASW $nnnn
	  case 0xCC: //   CPY $nnnn
	  case 0xCD: //   CMP $nnnn
	  case 0xCE: //   DEC $nnnn
	  case 0xD9: //   CMP $nnnn,Y
	  case 0xDC: //   CPZ $nnnn
	  case 0xDD: //   CMP $nnnn,X
	  case 0xDE: //   DEC $nnnn,X
	  case 0xEB: //   ROW $nnnn
	  case 0xEC: //   CPX $nnnn
	  case 0xED: //   SBC $nnnn
	  case 0xEE: //   INC $nnnn
	  case 0xF4: //   PHW #$nnnn
	  case 0xF9: //   SBC $nnnn,Y
	  case 0xFC: //   PHW $nnnn
	  case 0xFD: //   SBC $nnnn,X
	  case 0xFE: //   INC $nnnn,X
	    
	    single_instruction=1;
	    break;
	  }
	}
	if (single_instruction) break;
	    

	if (k>2) {
	  char similarity_name[MAX_SIZE];
	  snprintf(similarity_name,MAX_SIZE,"strings/");
	  int offset=strlen(similarity_name);
	  for(int b=0;b<k;b++) {
	    snprintf(&similarity_name[offset],MAX_SIZE-offset,"%02X",f1[i+b]);
	    offset+=2;
	  }
	  FILE *f=fopen(similarity_name,"r");
	  if (f) {
	    // Get explanation why this match is irrelevant
	    char line[1024]; line[0]=0;
	    if (0 == fgets(line,1024,f)) fprintf(stderr,"Warning: null fgets result\n");
	    while (line[0]&&line[strlen(line)-1]=='\r') line[strlen(line)-1]=0;
	    while (line[0]&&line[strlen(line)-1]=='\n') line[strlen(line)-1]=0;
	    if (verbose)
	      fprintf(stderr,"Ignoring $%04X = $%04X + %d (%s)\n",
		      i,j,k,line);
	    break;
	    fclose(f);
	  }

	  // Otherwise, the match is unexplained.
	  matches[k]++;
	  
	  // Display particularly long matches
	  printf("$%04X = $%04X :",i,j);
	  for(int b=0;b<k;b++) {
	    printf(" %02X",f1[i+b]);
	  }
	  printf("\n");
	  
	}
      }
    }
  }

  for(int i=0;i<MAX_SIZE;i++) {
    if (matches[i])
      printf("%6d unexplained matches of %d bytes\n",matches[i],i);
  }
  
  return 0;
}
