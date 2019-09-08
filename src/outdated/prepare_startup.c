#include <stdio.h>

#include "basic005.c"

unsigned char bytes[65536];
int len=0;

unsigned char colour_codes[16]={
  144,5,28,159,156,30,31,158,
  129,149,150,151,152,153,154,155
};

int main(int argc,char **argv)
{
  int reverse=0;
  int last_colour=-1;
  for(int y=0;y<24;y++) {
    unsigned char *line=&frame0000[43+y*40];
    unsigned char *colour=&frame0000[43+1000+y*40];
    int w=39;
    while(w&&line[w-1]==' ') w--;
    for(int x=0;x<w;x++) {
      // Update colour if required
      if (colour[x]!=last_colour) {
	bytes[len++]=colour_codes[colour[x]];
	last_colour=colour[x];
      }
      if ((line[x]&0x80)^reverse) {
	// Toggle reverse video flag
	if (reverse) bytes[len++]=0x92; else bytes[len++]=0x12;
	reverse^=0x80;
      }
      // Write char
      if (line[x]<0x20) bytes[len++]=line[x]+0x40;
      else if (line[x]>=0x40&&line[x]<0x60) bytes[len++]=line[x]+0x20;
      else if (line[x]>=0xe0) 
	bytes[len++]=(line[x]&0x7f)+0x40;
      else if (line[x]>=0x80) 
	bytes[len++]=line[x];
      else
	bytes[len++]=line[x];
    }
    
    // Add end of line marker if required
    if (w<40) bytes[len++]=13;
  }

  // Skip blank lines at the end
  while(bytes[len-1]==0x0d) len--;
  
  bytes[len++]=0;
  
  printf("; Used %d bytes\n",len);
  printf("startup_banner:");
  for(int i=0;i<len;i++) {
    if (!(i&0xf)) printf("\n  .byte ");
    printf("$%02X",bytes[i]);
    if ((i&0xf)!=0xf) printf(",");    
  }
  printf("\n");
}
