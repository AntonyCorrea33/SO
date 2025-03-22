#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(void){
	int valor = 5;
	fork();
	printf("%d: %d\n", (int)getpid(), valor);
	return 0;
}
