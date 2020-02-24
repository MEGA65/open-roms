/*
 * Copyright 2002-2010 Guillaume Cottenceau.
 * Copyright 2015-2018 Paul Gardner-Stephen.
 *
 * This software may be freely redistributed under the terms
 * of the X11 license.
 *
 */

/* ============================================================= */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <stdarg.h>

#define PNG_DEBUG 3
#include <png.h>

/* ============================================================= */

char *vhdl_prefix=
  "library IEEE;\n"
  "use IEEE.STD_LOGIC_1164.ALL;\n"
  "use ieee.numeric_std.all;\n"
  "use work.debugtools.all;\n"
  "\n"
  "--\n"
  "entity charrom is\n"
  "port (Clk : in std_logic;\n"
  "        address : in integer range 0 to 4095;\n"
  "        -- chip select, active low       \n"
  "        cs : in std_logic;\n"
  "        data_o : out std_logic_vector(7 downto 0);\n"
  "\n"
  "        writeclk : in std_logic;\n"
  "        -- Yes, we do have a write enable, because we allow modification of ROMs\n"
  "        -- in the running machine, unless purposely disabled.  This gives us\n"
  "        -- something like the WOM that the Amiga had.\n"
  "        writecs : in std_logic;\n"
  "        we : in std_logic;\n"
  "        writeaddress : in unsigned(11 downto 0);\n"
  "        data_i : in std_logic_vector(7 downto 0)\n"
  "      );\n"
  "end charrom;\n"
  "\n"
  "architecture Behavioral of charrom is\n"
  "\n"
  "-- 4K x 8bit pre-initialised RAM for character ROM\n"
  "\n"
  "type ram_t is array (0 to 4095) of std_logic_vector(7 downto 0);\n"
  "signal ram : ram_t := (\n"
  "\n";

char *vhdl_suffix=
  ");\n"
  "\n"
  "begin\n"
  "\n"
  "--process for read and write operation.\n"
  "PROCESS(Clk,ram,writeclk)\n"
  "BEGIN\n"
  "\n"
  "  if(rising_edge(writeClk)) then \n"
  "    if writecs='1' then\n"
  "      if(we='1') then\n"
  "        ram(to_integer(writeaddress)) <= data_i;\n"
  "      end if;\n"
  "    end if;\n"
  "    data_o <= ram(address);\n"
  "  end if;\n"
  "END PROCESS;\n"
  "\n"
  "end Behavioral;\n";

/* ============================================================= */

int x, y;

int width, height;
png_byte color_type;
png_byte bit_depth;

png_structp png_ptr;
png_infop info_ptr;
int number_of_passes;
png_bytep * row_pointers;

FILE *infile;
FILE *outfile;

/* ============================================================= */

void abort_(const char * s, ...)
{
  va_list args;
  va_start(args, s);
  vfprintf(stderr, s, args);
  fprintf(stderr, "\n");
  va_end(args);
  abort();
}

/* ============================================================= */

void read_png_file(char* file_name)
{
  unsigned char header[8];    // 8 is the maximum size that can be checked

  /* open file and test for it being a png */
  infile = fopen(file_name, "rb");
  if (infile == NULL)
    abort_("[read_png_file] File %s could not be opened for reading", file_name);

  fread(header, 1, 8, infile);
  if (png_sig_cmp(header, 0, 8))
    abort_("[read_png_file] File %s is not recognized as a PNG file", file_name);

  /* initialize stuff */
  png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

  if (!png_ptr)
    abort_("[read_png_file] png_create_read_struct failed");

  info_ptr = png_create_info_struct(png_ptr);
  if (!info_ptr)
    abort_("[read_png_file] png_create_info_struct failed");

  if (setjmp(png_jmpbuf(png_ptr)))
    abort_("[read_png_file] Error during init_io");

  png_init_io(png_ptr, infile);
  png_set_sig_bytes(png_ptr, 8);

  // Convert palette to RGB values
  png_set_expand(png_ptr);

  png_read_info(png_ptr, info_ptr);

  width = png_get_image_width(png_ptr, info_ptr);
  height = png_get_image_height(png_ptr, info_ptr);
  color_type = png_get_color_type(png_ptr, info_ptr);
  bit_depth = png_get_bit_depth(png_ptr, info_ptr);

  printf("Input-file is: width=%d, height=%d.\n", width, height);

  number_of_passes = png_set_interlace_handling(png_ptr);
  png_read_update_info(png_ptr, info_ptr);

  /* read file */
  if (setjmp(png_jmpbuf(png_ptr)))
    abort_("[read_png_file] Error during read_image");

  row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
  for (y=0; y<height; y++)
    row_pointers[y] = (png_byte*) malloc(png_get_rowbytes(png_ptr,info_ptr));

  png_read_image(png_ptr, row_pointers);

  if (infile != NULL) {
    fclose(infile);
    infile = NULL;
  }

  printf("Input-file is read and now closed\n");
}

/* ============================================================= */

struct rgb {
  int r;
  int g;
  int b;
};

struct rgb palette[2560];
int palette_first=16;
int palette_index=16; // only use upper half of palette

int palette_lookup(int r,int g, int b)
{
  int i;

  // Do we know this colour already?
  for(i=palette_first;i<palette_index;i++) {
    if (r==palette[i].r&&g==palette[i].g&&b==palette[i].b) {
      return i;
    }
  }
  
  // new colour
  if (palette_index>255) {
    fprintf(stderr,"Too many colours in image: Must be < 256, now up to %d\n",
	    palette_index);
  }
  if (palette_index>2559) exit(-1);
  
  // allocate it
  palette[palette_index].r=r;
  palette[palette_index].g=g;
  palette[palette_index].b=b;
  return palette_index++;
  
}

unsigned char nyblswap(unsigned char in)
{
  return ((in&0xf)<<4)+((in&0xf0)>>4);
}

void process_file(int mode, char *outputfilename)
{
  int multiplier=-1;
  if (png_get_color_type(png_ptr, info_ptr) == PNG_COLOR_TYPE_RGB)
    multiplier=3;

  if (png_get_color_type(png_ptr, info_ptr) == PNG_COLOR_TYPE_RGBA)
    multiplier=4;

  if (multiplier==-1) {
    fprintf(stderr,"Could not convert file to RGB or RGBA\n");
  }

  outfile=fopen(outputfilename,"w");
  if (outfile == NULL) {
    // could not open output file, so close all and exit
    if (infile != NULL) {
      fclose(infile);
      infile = NULL;
    }
    abort_("[process_file] File %s could not be opened for writing", outputfilename);
  }


  /* ============================ */

  if (mode==0) {
    printf("mode=0 (logo)\n");
    // Logo mode

    // Pre-load in C64 palette, so that those colours can be re-used if required
    
    palette[0]=(struct rgb){.r=0,.g=0,.b=0};
    palette[1]=(struct rgb){.r=0xff,.g=0xff,.b=0xff};
    palette[2]=(struct rgb){.r=0xab,.g=0x31,.b=0x26};
    palette[3]=(struct rgb){.r=0x66,.g=0xda,.b=0xff};
    palette[4]=(struct rgb){.r=0xbb,.g=0x3f,.b=0xb8};
    palette[5]=(struct rgb){.r=0x55,.g=0xce,.b=0x58};
    palette[6]=(struct rgb){.r=0x1d,.g=0x0e,.b=0x97};
    palette[7]=(struct rgb){.r=0xea,.g=0xf5,.b=0x7c};
    palette[8]=(struct rgb){.r=0xb9,.g=0x74,.b=0x18};
    palette[9]=(struct rgb){.r=0x78,.g=0x73,.b=0x00};
    palette[10]=(struct rgb){.r=0xdd,.g=0x93,.b=0x87};
    palette[11]=(struct rgb){.r=0x5b,.g=0x5b,.b=0x5b};
    palette[12]=(struct rgb){.r=0x8b,.g=0x8b,.b=0x8b};
    palette[13]=(struct rgb){.r=0xb0,.g=0xf4,.b=0xac};
    palette[14]=(struct rgb){.r=0xaa,.g=0x9d,.b=0xef};
    palette[15]=(struct rgb){.r=0xb8,.g=0xb8,.b=0xb8};
    
    
    for (y=0; y<height; y++) {
      png_byte* row = row_pointers[y];
      for (x=0; x<width; x++) {
	png_byte* ptr = &(row[x*multiplier]);
	int r,g,b;
	if (ptr)
	  { r=ptr[0]; g=ptr[1]; b=ptr[2]; // a=ptr[3];
	  } else { r=0; g=0; b=0; }

	int c=palette_lookup(r,g,b);

	if (c>255) printf("Too many colours at (%d,%d)\n",x,y);
	
	/* work out where in logo file it must be written.
	   image is made of 8x8 blocks.  So every 8 pixels across increases address
	   by 64, and every 8 pixels down increases pixel count by (64*8), and every
	   single pixel down increases address by 8.
	*/
	int address=0;
	address+=0x300; // space for palettes
	address+=(x&7)+(y&7)*8;
	address+=(x>>3)*64;
	//	if (size==SIZE_LOGO)
	  address+=(y>>3)*64*(width/8);
	  //	else
	  //	  address+=(y>>3)*64*40;

	fseek(outfile,address,SEEK_SET);
	int n=fwrite(&c,1,1,outfile);
	if (n!=1) {
	  fprintf(stderr,"Could not write pixel (%d,%d) @ $%x\n",x,y,address);
          if (outfile != NULL) {
            fclose(outfile);
            outfile = NULL;
          }
	  exit(-1);
	}
      }
    }

    fprintf(stderr,"Writing out palette of %d values\n",palette_index-palette_first);
    for(int i=0;i<256;i++){
      int address;
      unsigned char c;
      int v;
      
      address=i+0x000;
      v=palette[i].r;
      c=(v>>4)|((v&0xf)<<4);
      fseek(outfile,address,SEEK_SET);
      fwrite(&c,1,1,outfile);
      
      address=i+0x100;
      v=palette[i].g;
      c=(v>>4)|((v&0xf)<<4);
      fseek(outfile,address,SEEK_SET);
      fwrite(&c,1,1,outfile);

      address=i+0x200;
      v=palette[i].b;
      c=(v>>4)|((v&0xf)<<4);
      fseek(outfile,address,SEEK_SET);
      fwrite(&c,1,1,outfile);
    }
    
    
    if (outfile != NULL) {
      fclose(outfile);
      outfile = NULL;
    }

  }


  /* ============================ */
  if (mode==1) {

    unsigned char first_half[1024];
    
    printf("mode=1 (charrom)\n");
    // charrom mode

    int vhdl_mode=1;
    if (!strstr(outputfilename,".vhdl")) vhdl_mode=0;
    
    int bytes=0;
    if (vhdl_mode) fprintf(outfile,"%s",vhdl_prefix);
    if (width!=8) {
      fprintf(stderr,"Fonts must be 8 pixels wide\n");
    }

    int spots[8][8];
    int charsets;


    // 4KB = 2x 256 char = 2KB charsets
    for(charsets = 0 ; charsets<2 ; charsets++) {
      if (bytes>=4096) break;
      fprintf(stderr,"yheight=%d\n",height);
      for (y=0; y<height; y++) {
	png_byte* row = row_pointers[y];
	int byte=0;
	int yy=y&7;
	
	for (x=0; x<width; x++) {
	  png_byte* ptr = &(row[x*multiplier]);
	  int r=ptr[0],g=ptr[1],b=ptr[2]; //, a=ptr[3];
	  
	  if (x<8) {
	    if (r>0x7f||g>0x7f||b>0x7f) {
	      byte|=(1<<(7-x));
	      spots[yy][x]=1;
	    } else spots[yy][x]=0;
	  }
	}
	fflush(stdout);
	char comma = ',';
	if (bytes<1024) {
	  first_half[bytes]=byte;
	}
	bytes++;
	if (bytes>=4096) {
	  comma=' ';
	}
	if (vhdl_mode) fprintf(outfile,"x\"%02x\"%c",byte,comma);
	else fputc(byte,outfile);
	if (vhdl_mode) {
	  if ((y&7)==7) {
	    fprintf(outfile,"\n");
	    int yy;
	    for(yy=0;yy<8;yy++) {
	      fprintf(outfile,"-- [");
	      for(x=0;x<8;x++) {
		if (spots[yy][x]) fprintf(outfile,"*"); else fprintf(outfile," ");
	      }
	      fprintf(outfile,"]\n");
	    }
	  }
	}
      }

      // Fill in any missing bytes
      if (bytes<2048) {

	printf("Padding output file to 2048 after first charset\n");

	if (vhdl_mode) {
	  fprintf(outfile,",\n");

	for(;bytes<2048;bytes+=8) {
	  int reverse=bytes&0x400;
	  if (reverse) reverse=0xff;
	  
	  fprintf(outfile,"x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\"%c -- 0x%03x (set %d, char 0x%02x)\n",
		  first_half[(bytes+0)&0x3ff]^reverse,
		  first_half[(bytes+1)&0x3ff]^reverse,
		  first_half[(bytes+2)&0x3ff]^reverse,
		  first_half[(bytes+3)&0x3ff]^reverse,
		  first_half[(bytes+4)&0x3ff]^reverse,
		  first_half[(bytes+5)&0x3ff]^reverse,
		  first_half[(bytes+6)&0x3ff]^reverse,
		  first_half[(bytes+7)&0x3ff]^reverse,		  
		  ',',
		  bytes,bytes/2048,(bytes/8)&0xff);

	  fprintf(outfile,"\n");
	  int yy;
	  for(yy=0;yy<8;yy++) {
	    fprintf(outfile,"-- [");
	    for(x=0;x<8;x++) {
	      if ((first_half[(bytes+yy)&0x3ff]^reverse)&(1<<(7-x))) fprintf(outfile,"*"); else fprintf(outfile," ");
	    }
	    fprintf(outfile,"]\n");
	  }
	}
	} else {
	  // In raw mode, don't pad, or write charset twice
	  break;
	}
	
      }
      
    }
    // Fill in any missing bytes
    if (bytes<4096) {

      printf("Padding output file to 4096\n");

      if (vhdl_mode) {
	fprintf(outfile,",\n");
	for(;bytes<4096;bytes+=8) {
	  int reverse=bytes&0x400;
	  if (reverse) reverse=0xff;
	  
	  fprintf(outfile,"x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\",x\"%02X\"%c -- 0x%03x (set %d, char %d)\n",
		  first_half[(bytes+0)&0x3ff]^reverse,
		  first_half[(bytes+1)&0x3ff]^reverse,
		  first_half[(bytes+2)&0x3ff]^reverse,
		  first_half[(bytes+3)&0x3ff]^reverse,
		  first_half[(bytes+4)&0x3ff]^reverse,
		  first_half[(bytes+5)&0x3ff]^reverse,
		  first_half[(bytes+6)&0x3ff]^reverse,
		  first_half[(bytes+7)&0x3ff]^reverse,		  
		  bytes<(4096-8)?',':' ',
		  bytes,bytes/2048,(bytes/8)&0xff);
	}
      } else {
	// In raw mode, don't pad
      }
    }
    if (vhdl_mode) fprintf(outfile,"%s",vhdl_suffix);

    if (outfile != NULL) {
      fclose(outfile);
      outfile = NULL;
    }
  }

  /* ============================ */
  if (mode==2) {
    printf("mode=2 (hi-res prep)\n");
    // hi-res image preparation mode

    // int bytes=0;
    if (width%8||height%8) {
      fprintf(stderr,"Image must be multiple of 8 pixels wide and high\n");
    }
    int problems=0;
    int total=0;
    int threes=0;
    int fours=0;
    int ones=0;

    int tiles[8000][8][8];
    int tile_count=0;

    int this_tile[8][8];

    for (y=0; y<height; y+=8) {
      for (x=0; x<width; x+=8) {
	int yy,xx;
	int i;
	int colour_count=0;
	int colours[64];

	printf("[%d,%d]\n",x,y);

	total++;

	for(yy=y;yy<y+8;yy++) {
	  png_byte* row = row_pointers[yy];
	  for(xx=x;xx<x+8;xx++) {
	    png_byte* ptr = &(row[xx*multiplier]);
	    int r,g,b;
	    if (ptr&&(yy<height)&&(xx<width)) {
	      r=ptr[0]; g=ptr[1]; b=ptr[2];
	    } else {
	      r=0; g=0; b=0;
	    }
	    int c=r+256*g+65536*b;
	    this_tile[yy-y][xx-x]=c;
	    for(i=0;i<colour_count;i++) if (c==colours[i]) break;
	    if (i==colour_count) {
	      colours[colour_count++]=c;
	    }
	  }
	}

	for(i=0;i<tile_count;i++) {
	  int dud=0;
	  int xx,yy;
	  for(xx=0;xx<8;xx++)
	    for(yy=0;yy<8;yy++) {
	      if (this_tile[yy][xx]!=tiles[i][yy][xx]) dud=1;
	    }
	  if (!dud) break;
	}
	if (i==tile_count) {
	  int xx,yy;
	  for(xx=0;xx<8;xx++)
	    for(yy=0;yy<8;yy++) {
	      tiles[tile_count][yy][xx]=this_tile[yy][xx];
	    }
	  printf(".[%d]",tile_count); fflush(stdout);
	  tile_count++;
	  if (tile_count>=8000) {
	    fprintf(stderr,"Too many tiles\n");
            if (outfile != NULL) {
              fclose(outfile);
              outfile = NULL;
            }
	    exit(-1);
	  }
	}

	if (colour_count==1) ones++;
	if (colour_count==3) threes++;
	if (colour_count==4) fours++;
	if (colour_count>2) {
	  printf("%d colours in card\n",colour_count);
	  problems++;
	}
      }
    }
    printf("%d problem tiles out of %d total tiles\n",problems,total);
    printf("%d with 3, %d with 4, %d with only one colour\n",threes,fours,ones);
    printf("%d unique tiles\n",tile_count);
  }

  if (mode==3) {
    // Output set of 16-colour sprites
    int colour_count=0;
    int colours[16];
    fprintf(stderr,"Scanning colour palette...\n");
    for (y=0; y<height; y++) {
      for (x=0; x<width; x++) {
	int i;

	png_byte* row = row_pointers[y];
	png_byte* ptr = &(row[x*multiplier]);
	int r=ptr[0], g=ptr[1],b=ptr[2]; // , a=ptr[3];
	int c=r+256*g+65536*b;
	for(i=0;i<colour_count;i++) if (c==colours[i]) break;
	if (i==colour_count) {
	  if (colour_count>=16) {
	    fprintf(stderr,"Too many colours. Image must be 16-colours or less.\n");
	    exit(-1);
	  }
	  colours[colour_count++]=c;
	}
      }
    }
    fprintf(stderr,"%d unique colours found.\n",colour_count);

    // Avoid colour 0 if we can, to keep it for transparency
    int colour_offset=0;
    //    if (colour_count<16) colour_offset=1;


    int bytes_per_sprite=8*(height>>1);
    while (bytes_per_sprite%64) bytes_per_sprite++;
    fprintf(stderr,"Sprites are %d ($%02X) pixels high, and will occupy %d bytes (%d VIC-II sprite slots) each.\n",
	    height/2,height/2,bytes_per_sprite,bytes_per_sprite/64);    

    
    // Output palette
    unsigned char red[16];
    unsigned char green[16];
    unsigned char blue[16];
    int i;
    
    for(i=0;i<16;i++)
      {
	int idx=i;
	if (colour_offset) idx+=colour_offset;
	if (idx>=16) idx-=16;

	red[idx]=nyblswap(colours[i]&0xff);
	green[idx]=nyblswap((colours[i]>>8)&0xff);
	blue[idx]=nyblswap((colours[i]>>16)&0xff);
      }
    // Write magic string, height of sprites in pixels,
    // and the number of sprites, and how many slots per
    // sprite
    fwrite("M65SPRITE16",12,1,outfile);
    fputc(height/2,outfile);
    fputc(width/32,outfile);
    fputc(bytes_per_sprite&0xff,outfile);
    fputc(bytes_per_sprite>>8,outfile);
    fwrite(red,16,1,outfile);
    fwrite(green,16,1,outfile);
    fwrite(blue,16,1,outfile);
    

    // Output pixels
    for (x=0; x<width; x+=32) {
      int bytes_written=0;
      int xx;
      fprintf(stderr,"Writing sprite %d\n",x/32);
      for (y=0; y<height; y+=2) {
	for(xx=x;xx<(x+32);xx+=4) {
	  unsigned char byte;
	  unsigned char p1,p2;
	  int i;

	  png_byte* row = row_pointers[y];
	  png_byte* ptr = &(row[(xx+0)*multiplier]);
	  int r=ptr[0], g=ptr[1],b=ptr[2]; // , a=ptr[3];
	  int c=r+256*g+65536*b;
	  for(i=0;i<colour_count;i++) if (c==colours[i]) break;
	  p1=i;
	  ptr = &(row[(xx+2)*multiplier]);	  
	  r=ptr[0]; g=ptr[1]; b=ptr[2]; // , a=ptr[3];
	  c=r+256*g+65536*b;
	  for(i=0;i<colour_count;i++) if (c==colours[i]) break;
	  p2=i;
	  byte=(p1<<4)+p2;
	  fputc(byte,outfile);
	  bytes_written++;
	}
      }
      while(bytes_written<bytes_per_sprite) {
	fputc(0x00,outfile); 
	bytes_written++;
      }
    }
    
  }
  
}

/* ============================================================= */

int main(int argc, char **argv)
{
  if (argc != 4) {
    fprintf(stderr,"Usage: program_name <logo|charrom|hires|sprite16> <file_in> <file_out>\n");
    exit(-1);
  }

  int mode=-1;

  if (!strcasecmp("logo",argv[1])) mode=0;
  if (!strcasecmp("charrom",argv[1])) mode=1;
  if (!strcasecmp("hires",argv[1])) mode=2;
  if (!strcasecmp("sprite16",argv[1])) mode=3;
  if (mode==-1) {
    fprintf(stderr,"Usage: program_name <logo|charrom|hires|sprite16> <file_in> <file_out>\n");
    exit(-1);
  }

  printf("argv[0]=%s\n", argv[0]);
  printf("argv[1]=%s\n", argv[1]);
  printf("argv[2]=%s\n", argv[2]);
  printf("argv[3]=%s\n", argv[3]);

  printf("Reading %s\n",argv[2]);
  read_png_file(argv[2]);

  printf("Processing with mode=%d and output=%s\n", mode, argv[3]);
  process_file(mode,argv[3]);

  printf("done\n");

  if (infile != NULL) {
    fclose(infile);
    infile = NULL;
  }

  if (outfile != NULL) {
    fclose(outfile);
    outfile = NULL;
  }

  return 0;
}

/* ============================================================= */
