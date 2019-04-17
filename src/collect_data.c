/*
tcpclient.c
Copyright 2019, Paul Gardner-Stephen
Copyright 2012, Isaakidis Marios, Daniel Aguado
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <getopt.h>

//file found = 1
//file not found = 0

//write and overwrite =1
//apend =0

//tcpclient IP port
//argc1, argv0: tcpclient.exe
//argc2, argv1: IP address TCP Server
//argv3, argv2: TCP Server port

int set_nonblock(int fd)
{
  int retVal=0;


  do {
    if (fd==-1) break;
      
    int flags;
    if ((flags = fcntl(fd, F_GETFL, NULL)) == -1)
      {
        perror("fcntl");
//        LOG_ERROR("set_nonblock: fcntl(%d,F_GETFL,NULL)",fd);
        retVal=-1;
        break;
      }
    if (fcntl(fd, F_SETFL, flags | O_NONBLOCK | O_NDELAY) == -1)
    {
      perror("fcntl");
//      LOG_ERROR("set_nonblock: fcntl(%d,F_SETFL,n|O_NONBLOCK)",fd);
      return -1;
    }
  } while (0);
  return retVal;
}


int main (int argc, char *argv[]) {

  int collect_cycles=0;
  
  // KERNAL part is actually just under 7KB
  int rom_bottom=0xe4b7;
  int rom_top=0xffff;
  char *filename=NULL;

  int opt;
  
  while ((opt = getopt(argc, argv, "f:b:t:c:")) != -1) {
    switch (opt) {
    case 'b':
      rom_bottom=strtoll(optarg,NULL,16);
      break;
    case 't':
      rom_top=strtoll(optarg,NULL,16);
      break;
    case 'f':
      filename=optarg;
      break;
    case 'c':
      collect_cycles=atoi(optarg);
    default: /* '?' */
      fprintf(stderr, "Usage: %s [-b <ROM bottom hex>] [-t <ROM top hex>] [-f <file to load and run>] [-c <cycles to collect data>]\n",
	      argv[0]);
      exit(-1);
    }
  }

    int sockfd, rc, serverPort, nBytes;
    struct sockaddr_in localAddr, servAddr;
    struct hostent *h;

    /* Check parameters from command line */

    if(argc != 3)//check number of argc in command line
    {
        fprintf(stderr,"Usage: tcpclient [IP_server] [server_port]\n");
        return -1;
    }

    serverPort = atoi(argv[2]);
    if(serverPort<=0 || serverPort>65535)//check number of TCP server port
    {
        fprintf(stderr, "The port number given is wrong.\n");
        return -1;
    }

    h = gethostbyname(argv[1]);
    if(h==NULL)//check assigment of TCP server host
    {
        perror("Unknown host ");
        return -1;
    }

    /* Create TCP socket */
    
    servAddr.sin_family = h->h_addrtype;
    memcpy((char *) &servAddr.sin_addr.s_addr, h->h_addr_list[0], h->h_length);
    servAddr.sin_port = htons(serverPort);

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if(sockfd < 0)//check TCP socket is created correctly
    {
        perror("Cannot open socket ");
        return -1;
    }

    /* Bind any port number */

    localAddr.sin_family = AF_INET;
    localAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    localAddr.sin_port = htons(0);

    rc = bind(sockfd, (struct sockaddr *) &localAddr, sizeof(localAddr));
    if(rc < 0)//check TCP socket is bind correctly
    {
        perror("Cannot bind on TCP port ");
        close(sockfd);
        return -1;
    }

    /* Connect to TCP server */

    rc = connect(sockfd, (struct sockaddr *) &servAddr, sizeof(servAddr));
    if(rc < 0)//check TCP socket is connected correctly
    {
        perror("Cannot connect ");
        close(sockfd);
        return -1;
    }

    printf("Starting TCP client...\n");

    set_nonblock(sockfd);

    write(sockfd,"reset 0\r",strlen("reset 0\n"));

    int last_pc=0, last_sp=0xff;

    int max_cycles=0;

    if (filename) {
      /*
	To load and a program in VICE via the monitor interface:
	bload "filename" 0 07ff
	> 07ff 0 0
	keybuf run\x0d
	
      */
      char cmd[1024];
      snprintf(cmd,1024,"bload \"%s\" 0 07ff\r",filename);
      write(sockfd,cmd,strlen(cmd));
      usleep(1000000);
      write(sockfd,"> 07ff 0 0\r",11);
      usleep(100000);
      write(sockfd,"keybuf run\x0d",11);
    }

  
    
    unsigned char buffer[65536];
    while(1) {
      nBytes = read(sockfd, buffer, sizeof(buffer));
      if (nBytes >= 1) {
	write(sockfd,"step\rstep\rstep\rstep\r",5*1);
	// fprintf(stdout,"%d: %s\n",nBytes,buffer);
	int pc,sp,cycles;
	int nf=sscanf((char *)buffer,".C:%x%*[^:]:%*x X:%*x Y:%*x SP:%x %*[^ ] %d",&pc,&sp,&cycles);
	if (nf==3) {
	  //	    fprintf(stdout,"%x %x %d\n",pc,sp,cycles);
	  // Detect entry into ROM via code 
	  if (pc>=rom_bottom&&pc<=rom_top) {
	    if (last_pc<rom_bottom||last_pc>rom_top) {
	      // PC has just entered the ROM
	      fprintf(stdout,"$%04x called from $%04x @ cycle %d\n",pc,last_pc,cycles);
	    }
	  }
	  // Detect entry into ROM via interrupt
	  if (pc>=rom_bottom&&pc<=rom_top)
	    if (sp==(last_sp-3)) {
	      // PC has just entered the ROM
	      fprintf(stdout,"$%04x called from via interrupt @ cycle %d\n",pc,cycles);
	    }
	  last_pc=pc; last_sp=sp;
	}

	if (cycles>(max_cycles+10000)) {
	  max_cycles=cycles;
	  //	  fprintf(stderr,"%d cycles\n",cycles);
	}

	if (cycles>=collect_cycles)  break;
	
      }  else usleep(1);
    }
    close(sockfd);
    return 0;
}
