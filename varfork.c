#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main (void) {
	pid_t pidHijo;
	int valor = 5;
	pidHijo = fork();

	if(pidHijo > 0){
		printf("Soy proceso padre %d y el abuelo es %d \n", (int)getpid(), (int)getppid());
		valor = 13;
	}


	printf("%d: %d\n", (int)getpid(), valor);
	return 0;
}
