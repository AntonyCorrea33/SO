#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>

int main(){
	int n = 4;
	pid_t pidHijo;

	for(int i = 0;i<n;i++){
		pidHijo=fork();
		if(pidHijo > 0){
			break;
		}
	}

	printf("Proceso %d con padre %d\n", getpid(), getppid());

	return 0;
}
