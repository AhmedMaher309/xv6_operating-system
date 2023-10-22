#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int
main(int argc, char *argv[])
{
	int p[2];
	int rt = pipe(p);

    //  error in piping
    if(rt == -1){
		fprintf(2, "Error: pipe(fd) error.\n");
	}

    int pid = fork();
    // error in forking
	if(pid == -1){
		fprintf(2, "Error in forking\n");
		exit(1);
	}

	//child process
	if (pid == 0){
		char byte;
		read(p[0], &byte, 1);
		close(p[0]);
		fprintf(1, "%d: received ping\n", getpid());
		write(p[1], &byte, 1);
		close(p[1]);
	}

	// parent process
	else{
		char byte;      
		write(p[1], &byte, 1);
		close(p[1]);
        wait(0);
		read(p[0], &byte, 1);
		close(p[0]);
		printf("%d: received pong\n", getpid() );;
	}
  exit(0);
}
