#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

// XXX - Find out which of these are standard error messages, and thus not subject
// to any copyright claims, versus any that are specific to Commodore, and thus
// could be copyright.
char *error_list[]={
  "TOO MANY FILES",
  "FILE OPEN",
  "FILE NOT OPEN",
  "FILE NOT FOUND",
  "DEVICE NOT PRESENT",
  "NOT INPUT FILE",
  "NOT OUTPUT FILE",
  "MISSING FILENAME",
  "ILLEGAL DEVICE NUMBER",
  "NEXT WITHOUT FOR",
  "SYNTAX",
  "RETURN WITHOUT GOSUB",
  "OUT OF DATA",
  "ILLEGAL QUANTITY",
  "OVERFLOW",
  "OUT OF MEMORY",
  "UNDEF\'D STATEMENT",
  "BAD SUBSCRIPT",
  "REDIM\'D ARRAY",
  "DIVISION BY ZERO",
  "ILLEGAL DIRECT",
  "TYPE MISMATCH",
  "STRING TOO LONG",
  "FILE DATA",
  "FORMULA TOO COMPLEX",
  "CAN\'T CONTINUE",
  "UNDEF\'D FUNCTION",
  "VERIFY",
  "LOAD",
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

struct char_freq {
  char c;
  int count;
};

int cmpfreq(const void *a,const void *b)
{
  const struct char_freq *aa=a,*bb=b;
  if (aa->count<bb->count) return 1;
  if (aa->count>bb->count) return -1;
  return 0;
}

struct char_freq char_freqs[31];
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

int main(void)
{
  int raw_size=0;

  // Get letter frequencies
  for(int i=0;i<26;i++) char_freqs[i].count=0;
  for(int i=0;error_list[i];i++) {
    for(int j=0;error_list[i][j];j++)
      if (error_list[i][j]!=' ') {
	int char_num=0;
	for(char_num=0;char_num<char_max;char_num++)
	  if (error_list[i][j]==char_freqs[char_num].c) break;
	if (char_num>(14+15)) {
	  fprintf(stderr,"Too many unique characters in message list.  Max is 29\n");
	  exit(-1);
	}
	if (char_num>=char_max) char_max=char_num+1;
	char_freqs[char_num].c=error_list[i][j];
	char_freqs[char_num].count++;
      }
  }
  qsort(char_freqs,char_max,sizeof(struct char_freq),cmpfreq);
  fprintf(stderr,"Letter frequencies:\n");
  for(int i=0;i<char_max;i++) fprintf(stderr,"'%c' : %d\n",char_freqs[i].c,char_freqs[i].count);

  // Get 14 most frequent out to use as 4-bit tokens 1 - 14.
  // Token 0 = end of word.
  // Token 15 indicates opposite nybl identifies which of the other 15 possible values is used
  // for less-frequent letters. (Low nybl $0 is reserved to make it easy to find end of each
  // compressed word, at the cost of one possible symbol).
  // Thus common letters take 4 bits, and uncommon ones take 8, i.e., they can never be longer,
  // but can be upto 1/2 the length.
  
  
  for(int i=0;error_list[i];i++) raw_size+=strlen(error_list[i]);
  fprintf(stderr,"Error list takes %d bytes raw.\n",raw_size);

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
    int nybl_waiting=0;
    int nybl_val=0;
    for(int j=0;words[i][j];j++) {
      int char_num;
      for(char_num=0;char_num<char_max;char_num++)
	if (words[i][j]==char_freqs[char_num].c) break;
      fprintf(stderr,"'%c' = char #%d ",words[i][j],char_num);
      if (char_num<14) {
	if (nybl_waiting) {
	  // We have a nybl already waiting, so join them up
	  int byte=(nybl_val<<4)+char_num;
	  packed_words[packed_len++]=byte;
	  nybl_waiting=0;
	  fprintf(stderr," M[$%02x]",byte);
	} else {
	  // Queue this nybl to pack in a byte
	  nybl_waiting=1;
	  nybl_val=char_num;
	  fprintf(stderr," Q[$%x]",char_num);
	}
      } else {
	// It's a less frequent letter that we have to encode
	// using a whole byte, and flush out any waiting nybl with a
	// $F token to indicate long code follows.
	if (nybl_waiting) {
	  int byte=(nybl_val<<4)+0xF;
	  packed_words[packed_len++]=byte;
	  nybl_waiting=0;
	  fprintf(stderr," F[$%02x]",byte);
	}
	packed_words[packed_len++]=0xF1+(char_num-14);
	fprintf(stderr," L[$%02x]",0xF1+(char_num-14));
      }
      fprintf(stderr,"\n");
    }

    // Flush any pending nybl out, or if none, write $00
    if (nybl_waiting) {
      int byte=(nybl_val<<4)+0x0;
      packed_words[packed_len++]=byte;
      nybl_waiting=0;
      fprintf(stderr,"    EF[$%02x]\n",byte);
    } else {
      int byte=0x00;
      packed_words[packed_len++]=byte;
      nybl_waiting=0;
      fprintf(stderr,"    E[$%02x]\n",byte);      
    }
    
  }
  fprintf(stderr,"Words packed in %d bytes\n",packed_len);
  fprintf(stderr,"%d token bytes used to encode all messages.\n",token_count);

  int word_bytes=0;
  for(int i=0;i<word_count;i++) word_bytes+=strlen(words[i]);
  fprintf(stderr,"Plus %d bytes for the words\n",packed_len);

  fprintf(stderr,"Space saving = %d bytes\n",raw_size-packed_len-token_count);

  printf("packed_message_chars:\n");
  for(int i=0;i<char_max;i++)
    printf("\t.byte $%02X ; '%c'\n",char_freqs[i].c,char_freqs[i].c);

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
  
}
