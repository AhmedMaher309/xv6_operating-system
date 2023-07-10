#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void pingpong(){
	int p[2];
	pipe(p);

	if(fork() == -1){
		printf("Error in forking\n");
		exit(1);
	}

	//child process
	if (fork() == 0){
		char recv_byte;
		read(p[0], &recv_byte, 1);
		close(p[0]);
		printf("%d:  received ping\n", getpid());

		//send the byte 
		char send_byte = 'c';
		write(p[1], &send_byte, 1);
	}

	// parent process
	else{
		char send_byte = 'c';      
		write(p[1], &send_byte, 1);
		close(p[1]);
        wait(0);
		// recieve the byte
		char recv_byte;
		read(p[0], &recv_byte, 1);
		printf("%d: received pong\n", getpid() );;
	}
}

int
main(int argc, char *argv[])
{
  if(argc != 1){
	fprintf(2, "error: expecting one argument\n");
    exit(1);
  }
  pingpong();
  exit(0);
}
