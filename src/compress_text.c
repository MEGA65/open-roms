#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

//   https://www.c64-wiki.com/wiki/BASIC_token
/*
  The URLs here provide examples of other BASIC dialects that include the specified commands
  or keywords.
  All except VERIFY are known with certainty to be part of other BASIC dialects, and thus
  cannot be subject to copyright infringement when implemented on a C64.

  The VERIFY Command however appears in other programming languages, and as a single word,
  is the obvious complement to LOAD and SAVE when considering the following storage functions:

  1. Load a file from storage into memory.
  2. Save a file from memory to storage.
  3. Verify that a file has been correctly written from memory to storage.

  Note that verify is the key verb in the behaviour of this function. Therefore it is the
  obvious choice for the name for such a function, taking into account the convention of
  LOAD and SAVE. Indeed, that this is so is highlighted by the fact that it was used in the
  C64 ROM.  Therefore there is no exercise of creativity here, and a reasonable person would
  likely select this name independently. Also, single words cannot be copyright.
  
  Further, the list is a list of facts, and thus not copyrightable.

  We sourced the list from a public source, https://www.c64-wiki.com/wiki/BASIC, which has
  been public on the internet for a long time, as have many other similar sources.
  That website offers the page under the GFDL license, and we can therefore take the list
  under those license terms if we wish, should the need arise.

  Note that in providing these justifications above, we do not in any way acknowledge that 
  without these conditions that the BASIC keyword list could be copyright, but provide this
  information as a further layer of defence against any claims that it could somehow 
  infringe on the copyrights of the C64/C65/C128 etc ROMs.

*/
char *keyword_list[]={
  "END",     // https://www.landsnail.com/a2ref.htm
  "FOR",     // https://www.landsnail.com/a2ref.htm
  "NEXT",     // https://www.landsnail.com/a2ref.htm
  "DATA",     // https://www.landsnail.com/a2ref.htm
  "INPUT#",     // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
  "INPUT",     // https://www.landsnail.com/a2ref.htm
  "DIM",     // https://www.landsnail.com/a2ref.htm
  "READ",     // https://www.landsnail.com/a2ref.htm
  "LET",     // https://en.wikipedia.org/wiki/Atari_BASIC
  "GOTO",     // https://www.landsnail.com/a2ref.htm
  "RUN",     // https://www.landsnail.com/a2ref.htm
  "IF",     // https://www.landsnail.com/a2ref.htm
  "RESTORE",     // https://www.landsnail.com/a2ref.htm
  "GOSUB",     // https://www.landsnail.com/a2ref.htm
  "RETURN",     // https://www.landsnail.com/a2ref.htm
  "REM",     // https://www.landsnail.com/a2ref.htm
  "STOP",     // https://www.landsnail.com/a2ref.htm
  "ON",     // https://www.landsnail.com/a2ref.htm
  "WAIT",     // http://www.picaxe.com/BASIC-Commands/Time-Delays/wait/
  "LOAD",     // https://www.landsnail.com/a2ref.htm
  "SAVE",     // https://www.landsnail.com/a2ref.htm
  "VERIFY",     // https://golang.org/cmd/go/
  "DEF",     // https://www.landsnail.com/a2ref.htm
  "POKE",     // https://www.landsnail.com/a2ref.htm
  "PRINT#",     // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
  "PRINT",     // https://www.landsnail.com/a2ref.htm
  "CONT",     // https://www.landsnail.com/a2ref.htm
  "LIST",     // https://www.landsnail.com/a2ref.htm
  "CLR",     // Apple I Replica Creation: Back to the Garage, p125
  "CMD",     // https://en.wikipedia.org/wiki/List_of_DOS_commands
  "SYS",     // https://www.lifewire.com/dos-commands-4070427
  "OPEN",     // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
  "CLOSE",     // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
  "GET",     // https://www.landsnail.com/a2ref.htm
  "NEW",     // https://www.landsnail.com/a2ref.htm
  "TAB(",     // http://www.antonis.de/qbebooks/gwbasman/tab.html
  "TO",     // https://www.landsnail.com/a2ref.htm
  "FN",     // https://www.landsnail.com/a2ref.htm
  "SPC(",     // http://www.antonis.de/qbebooks/gwbasman/spc.html
  "THEN",     // https://www.landsnail.com/a2ref.htm
  "NOT",     // https://www.landsnail.com/a2ref.htm
  "STEP",     // https://www.landsnail.com/a2ref.htm
  "+",     // https://www.landsnail.com/a2ref.htm
  "-",     // https://www.landsnail.com/a2ref.htm
  "*",     // https://www.landsnail.com/a2ref.htm
  "/",     // https://www.landsnail.com/a2ref.htm
  "^",     // https://www.landsnail.com/a2ref.htm
  "AND",     // https://www.landsnail.com/a2ref.htm
  "OR",     // https://www.landsnail.com/a2ref.htm
  ">",     // https://www.landsnail.com/a2ref.htm
  "=",     // https://www.landsnail.com/a2ref.htm
  "<",     // https://www.landsnail.com/a2ref.htm
  "SGN",     // https://www.landsnail.com/a2ref.htm
  "INT",     // https://www.landsnail.com/a2ref.htm
  "ABS",     // https://www.landsnail.com/a2ref.htm
  "USR",     // https://www.landsnail.com/a2ref.htm
  "FRE",     // http://www.antonis.de/qbebooks/gwbasman/fre.html
  "POS",     // http://www.antonis.de/qbebooks/gwbasman/pos.html
  "SQR",     // https://www.landsnail.com/a2ref.htm
  "RND",     // https://www.landsnail.com/a2ref.htm
  "LOG",     // https://www.landsnail.com/a2ref.htm
  "EXP",     // https://www.landsnail.com/a2ref.htm
  "COS",     // https://www.landsnail.com/a2ref.htm
  "SIN",     // https://www.landsnail.com/a2ref.htm
  "TAN",     // https://www.landsnail.com/a2ref.htm
  "ATN",     // https://www.landsnail.com/a2ref.htm
  "PEEK",     // https://www.landsnail.com/a2ref.htm
  "LEN",     // https://www.landsnail.com/a2ref.htm
  "STR$",     // https://www.landsnail.com/a2ref.htm
  "VAL",     // https://www.landsnail.com/a2ref.htm
  "ASC",     // https://www.landsnail.com/a2ref.htm
  "CHR$",     // https://www.landsnail.com/a2ref.htm
  "LEFT$",     // https://www.landsnail.com/a2ref.htm
  "RIGHT$",     // https://www.landsnail.com/a2ref.htm
  "MID$",     // https://www.landsnail.com/a2ref.htm
  "GO",     // https://en.wikipedia.org/wiki/Goto
  NULL    
};

/*
  These error messages are generally so well known, that it seems silly to have to even point out that they are
  so widely used and known, if not completely genericised.
  The most of them are inherited from the MICROSOFT BASIC on which the C64's BASIC is based, so for those, there
  cannot even be any claim to copyright over them in any exclusive way.

  However, copyright of such short phrases that express ideas in short form cannot be copyrighted:
  https://fairuse.stanford.edu/2003/09/09/copyright_protection_for_short/
 */
char *error_list[]={
  "TOO MANY FILES",        // https://docs.microsoft.com/en-us/dotnet/visual-basic/language-reference/error-messages/too-many-files
  "FILE OPEN",             // https://forums.autodesk.com/t5/3ds-max-forum/quot-file-open-error-quot/td-p/4036150
  "FILE NOT OPEN",         // https://www.synthetos.com/topics/file-not-open-error/
  "FILE NOT FOUND",        // https://answers.microsoft.com/en-us/windows/forum/windows_10-files/file-not-found-check-the-file-name-and-try-again/0734e837-b9f7-485e-93c5-5592f804b4c8
  "DEVICE NOT PRESENT",    // https://answers.microsoft.com/en-us/windows/forum/all/device-not-present/d9f96498-cf92-4ba0-9076-a206cf058131
  "NOT INPUT FILE",        // https://stackoverflow.com/questions/13055889/sed-with-literal-string-not-input-file/37682812 http://iama.stupid.cow.org/OldComputerMagazines/Commodore%20Power-Play%20100%25/Commodore_Power-Play_1985_Issue_16_V4_N04_Aug_Sep.pdf
  "NOT OUTPUT FILE",       // http://www.un4seen.com/forum/?topic=12547.0
  "MISSING FILENAME",      // https://arduino.stackexchange.com/questions/22839/missing-filename-compilation-error
  "ILLEGAL DEVICE NUMBER", // https://comp.unix.solaris.narkive.com/dkqcQFg3/svm-mirror-not-working-illegal-major-device-number
  "NEXT WITHOUT FOR",      // https://stackoverflow.com/questions/18232928/compile-error-next-without-for-vba
  "SYNTAX",                // https://en.wikipedia.org/wiki/Syntax_error
  "RETURN WITHOUT GOSUB",  // https://stackoverflow.com/questions/11467746/return-without-gosub-when-using-subforms-in-access
  "OUT OF DATA",           // http://forum.qbasicnews.com/index.php?topic=8619.0
  "ILLEGAL QUANTITY",      // https://community.dynamics.com/ax/f/33/t/238113
  "OVERFLOW",              // https://www.webopedia.com/TERM/O/overflow_error.html
  "OUT OF MEMORY",         // https://support.microsoft.com/en-au/help/126962/out-of-memory-error-message-appears-when-you-have-a-large-number-of-pr
  "UNDEF\'D STATEMENT",    // http://ivanx.com/appleii/magicgoto/
  "BAD SUBSCRIPT",         // https://www.computing.net/answers/windows-8/how-does-bad-subscript-error-appear-in-gwbasic/2301.html
  "REDIM\'D ARRAY",        // https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "DIVISION BY ZERO",      // https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "ILLEGAL DIRECT",        // https://hwiegman.home.xs4all.nl/gw-man/Appendix%20A.html
  "TYPE MISMATCH",         // https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "STRING TOO LONG",       // https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "FILE DATA",             // https://www.minitool.com/data-recovery/data-error-crc.html
  "FORMULA TOO COMPLEX",   // https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "CAN\'T CONTINUE",       // https://hwiegman.home.xs4all.nl/gw-man/Appendix%20A.html
  "UNDEF\'D FUNCTION",     // https://www.saatchiart.com/print/Painting-Undef-d-Function-3495/16167/3829193/view
  "VERIFY",                // https://forums.openvpn.net/viewtopic.php?t=22040
  "LOAD",                  // https://www.discogs.com/Gimmik-Load-Error/release/482462
  // Non-error messages
  "READY.\r", // #29       // https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconc_whatistsonative.htm https://github.com/stefanhaustein/expressionparser
  "LOADING",               // https://community.tibco.com/wiki/how-show-loading-prompt-when-reloading-external-data
  "VERIFYING",             // https://discussions.apple.com/thread/8087203
  "SAVING",
  "ERROR", // #33            // Simply the word error that is attached to the other parts of messages https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
  "BYTES FREE.\r\r", // #34 // https://github.com/stefanhaustein/expressionparser
  NULL};

// Token $FF is end of message, so we can have only 255 unique words
#define MAX_WORDS 255
char *words[MAX_WORDS];
int word_count=0;

#define MAX_LEN 1024
unsigned char message_tokens[MAX_LEN];
int token_count=0;

unsigned char packed_words[MAX_LEN];
int packed_len=0;

unsigned char packed_keywords[MAX_LEN];
int packedkey_len=0;

struct char_freq {
  unsigned char c;
  int count;
};

int total_chars=0;
int repeats=0;

int cmpfreq(const void *a,const void *b)
{
  const struct char_freq *aa=a,*bb=b;
  if (aa->count<bb->count) return 1;
  if (aa->count>bb->count) return -1;
  return 0;
}

#define MAX_CHARS 256
struct char_freq char_freqs[MAX_CHARS];
int char_max=0;

int find_word(char *w)
{
  int i;
  for(i=0;i<word_count;i++) {
    if (!strcmp(w,words[i])) {
      //      fprintf(stderr,"Word '%s' is repeated.\n",w);
      return i;
    }
  }
  words[word_count++]=strdup(w);
  return word_count-1;
}

void process_word(char *w)
{
  int num=find_word(w);
  message_tokens[token_count++]=num;
  return;
}

void end_of_message(void)
{
  message_tokens[token_count++]=0xFF;
}

int not_vowel(char c)
{
  switch(c) {
  case 'A': case 'E': case 'I': case 'O': case 'U':
    return 0;
  }
  return 1;
}

int calc_stats(const char *s)
{
  for(int j=0;s[j];j++)
    if (s[j]!=' ') {
      int char_num=0;
      for(char_num=0;char_num<char_max;char_num++)
	if (s[j]==char_freqs[char_num].c) break;
      if (s[j]&0x80) fprintf(stderr,"Word '%s' contains funny char 0x%02x\n",s,s[j]);
      if (char_num>MAX_CHARS) {
	fprintf(stderr,"Too many unique characters in message list.  Max is %d\n",MAX_CHARS);
	exit(-1);
      }
      if (char_num>=char_max) char_max=char_num+1;
      char_freqs[char_num].c=s[j];
      char_freqs[char_num].count++;
      total_chars++;
      if (j&&s[j]==s[j-1]) repeats++;
    }
  return 0;
}

int pack_word(const char *w,unsigned char *out,int *len)
{

  fprintf(stderr,"Packing word '%s' at offset 0x%03x\n",w,*len);
  int nybl_waiting=0;
  int nybl_val=0;
  for(int j=0;w[j];j++) {
    int char_num;
    for(char_num=0;char_num<char_max;char_num++)
      if (w[j]==char_freqs[char_num].c) break;
    fprintf(stderr,"'%c' = char #%d ",w[j],char_num);
    if (char_num<14) {
      if (nybl_waiting) {
	// We have a nybl already waiting, so join them up
	int byte=(nybl_val<<4)+(char_num+1);
	out[(*len)++]=byte;
	nybl_waiting=0;
	fprintf(stderr," M[$%02x]",byte);
      } else {
	// Queue this nybl to pack in a byte
	nybl_waiting=1;
	nybl_val=char_num+1;
	fprintf(stderr," Q[$%x]",char_num+1);
      }
    } else {
      // It's a less frequent letter that we have to encode
      // using a whole byte, and flush out any waiting nybl with a
      // $F token to indicate long code follows.
      if (nybl_waiting) {
	int byte=(nybl_val<<4)+0xF;
	out[(*len)++]=byte;
	nybl_waiting=0;
	fprintf(stderr," F[$%02x]",byte);
	if (char_num&0x80) {
	  fprintf(stderr,"ERROR: Extended characters must be < 0x80\n");
	  exit(-1);
	}
	if (w[j+1]) {
	  out[(*len)++]=(char_num<<1)+1;
	  fprintf(stderr," XS[$%02x]",char_num);
	}
        else {
	  out[(*len)++]=(char_num<<1)+0;
	  fprintf(stderr," XS0[$%02x]\n",char_num);
	  return 0;
	}
      } else {
	if (char_num < (14+13)) {
	  out[(*len)++]=0xF1+(char_num-14);
	  fprintf(stderr," L[$%02x]",0xF1+(char_num-14));
	} else {
	  if (w[j+1]) {
	    out[(*len)++]=0xFF;
	    out[(*len)++]=char_num;
	    fprintf(stderr," X[$FF,$%02x]",char_num);
	  }
	  else {
	    out[(*len)++]=0xFE;
	    out[(*len)++]=char_num;
	    fprintf(stderr," X0[$FE,$%02x]\n",char_num);
	    return 0;
	  }
	}
      }
    }
    fprintf(stderr,"\n");
  }
  
  // Flush any pending nybl out, or if none, write $00
  if (nybl_waiting) {
    int byte=(nybl_val<<4)+0x0;
    out[(*len)++]=byte;
    nybl_waiting=0;
    fprintf(stderr,"    EF[$%02x]\n",byte);
  } else {
    int byte=0x00;
    out[(*len)++]=byte;
    nybl_waiting=0;
    fprintf(stderr,"    E[$%02x]\n",byte);      
  }
  return 0;
}

int main(void)
{
  int raw_size=0;
  int keyraw_size=0;

  // Get letter frequencies
  for(int i=0;i<26;i++) char_freqs[i].count=0;
  for(int i=0;error_list[i];i++) calc_stats(error_list[i]);
  for(int i=0;keyword_list[i];i++) calc_stats(keyword_list[i]);
  
  qsort(char_freqs,char_max,sizeof(struct char_freq),cmpfreq);
  fprintf(stderr,"Letter frequencies of %d chars (%d unique, %d repeats):\n",total_chars,char_max,repeats);
  for(int i=0;i<char_max;i++) fprintf(stderr,"%02x '%c' : %d (%.2f bits)\n",
				      char_freqs[i].c,
				      char_freqs[i].c,
				      char_freqs[i].count,log(total_chars*1.0/char_freqs[i].count)/log(2));

  // Get 14 most frequent out to use as 4-bit tokens 1 - 14.
  // Token 0 = end of word.
  // Token 15 indicates opposite nybl identifies which of the other 15 possible values is used
  // for less-frequent letters. (Low nybl $0 is reserved to make it easy to find end of each
  // compressed word, at the cost of one possible symbol).
  // Thus common letters take 4 bits, and uncommon ones take 8, i.e., they can never be longer,
  // but can be upto 1/2 the length.
  
  
  for(int i=0;error_list[i];i++) raw_size+=strlen(error_list[i]);
  for(int i=0;keyword_list[i];i++) keyraw_size+=strlen(keyword_list[i]);

  for(int i=0;error_list[i];i++)
    {
      char word[1024];
      int offset=0;
      for(int j=0;error_list[i][j];j++) {
	if (error_list[i][j]==' ') {
	  // Found word boundary
	  int w=0;
	  for(int k=offset;k<j;k++) word[w++]=error_list[i][k];
	  word[w++]=0;
	  offset=j+1;
	  //	  fprintf(stderr,"Found word '%s'\n",word);
	  process_word(word);
	}
      }
      {
	// Get last word on line
	int w=0;
	for(int k=offset;k<error_list[i][k];k++) word[w++]=error_list[i][k];
	word[w++]=0;
	//	fprintf(stderr,"Found word '%s'\n",word);
	process_word(word);
	end_of_message();
      }
    }	

  // Now encode the words
  for(int i=0;i<word_count;i++) {
    pack_word(words[i],packed_words,&packed_len);    
  }
  for(int i=0;keyword_list[i];i++) {
    pack_word(keyword_list[i],packed_keywords,&packedkey_len);    
  }

  int word_bytes=0;
  for(int i=0;i<word_count;i++) word_bytes+=strlen(words[i]);

  if (packed_len>255) {
    fprintf(stderr,"ERROR: packed_len>255\n");
    exit(-1);
  }
  if (token_count>255) {
    fprintf(stderr,"ERROR: token_count>255\n");
    exit(-1);
  }
  
  printf("packed_message_chars:\n");
  for(int i=0;i<char_max;i++) {
    printf("\t.byte $%02X ; '%c' ",char_freqs[i].c,char_freqs[i].c);
    if (i<14) printf(" = $%x (nybl)\n",i+1);
    else if (i<(14+13)) printf(" = $F%x / $xF $%02X\n",i-14+1,char_freqs[i].c);
    else printf(" = $FE/F + $%02X\n",char_freqs[i].c);
  }

  printf("packed_message_tokens:\n");
  for(int i=0;i<token_count;i++)
    {
      if ((token_count-i)>=8) {
	printf("\t.byte $%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x\n",
	       message_tokens[i+0],message_tokens[i+1],message_tokens[i+2],message_tokens[i+3],
	       message_tokens[i+4],message_tokens[i+5],message_tokens[i+6],message_tokens[i+7]);
	i+=7;
      } else
	printf("\t.byte $%02x\n",message_tokens[i]);
    }
  
  printf("packed_message_words:\n");
  for(int i=0;i<packed_len;i++)
    {
      if ((packed_len-i)>=8) {
	printf("\t.byte $%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x\n",
	       packed_words[i+0],packed_words[i+1],packed_words[i+2],packed_words[i+3],
	       packed_words[i+4],packed_words[i+5],packed_words[i+6],packed_words[i+7]);
	i+=7;
      } else
	printf("\t.byte $%02x\n",packed_words[i]);
    }

  printf("packed_keywords:\n");
  for(int i=0;i<packedkey_len;i++)
    {
      if ((packed_len-i)>=8) {
	printf("\t.byte $%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x,$%02x\n",
	       packed_keywords[i+0],packed_keywords[i+1],packed_keywords[i+2],packed_keywords[i+3],
	       packed_keywords[i+4],packed_keywords[i+5],packed_keywords[i+6],packed_keywords[i+7]);
	i+=7;
      } else
	printf("\t.byte $%02x\n",packed_keywords[i]);
    }
  
  fprintf(stderr,"Error list takes %d bytes raw.\n",raw_size);
  fprintf(stderr,"%d token bytes used to encode all messages.\n",token_count);
  fprintf(stderr,"Plus %d bytes for the words\n",packed_len);
  fprintf(stderr,"Space saving = %d bytes\n",raw_size-packed_len-token_count);

  fprintf(stderr,"\nKeyword list takes %d bytes raw.\n",keyraw_size);
  fprintf(stderr,"Keyword list takes %d bytes packed.\n",packedkey_len);
  
}
