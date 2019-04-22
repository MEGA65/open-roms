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
	if (char_num>(14+16)) {
	  fprintf(stderr,"Too many unique characters in message list.  Max is 30\n");
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
  // Token 15 indicates opposite nybl identifies which of the other 16 possible values is used
  // for less-frequent letters.
  // Thus common letters take 4 bits, and uncommon ones take 8.
  
  
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

  fprintf(stderr,"%d token bytes used to encode all messages.\n",token_count);

  int word_bytes=0;
  for(int i=0;i<word_count;i++) word_bytes+=strlen(words[i]);
  fprintf(stderr,"Plus %d bytes for the words\n",word_bytes);

  fprintf(stderr,"Space saving = %d bytes\n",raw_size-word_bytes-token_count);
	  
  
}
