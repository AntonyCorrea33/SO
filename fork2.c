#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(void){
	int valor = 5;
	int id = (int)getpid();
	fork();
	printf("%d: %d ; %d\n", (int)getpid(), valor, id);
	return 0;
}
