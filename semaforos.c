#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int suma;
void *mi_hilo(void *valor){
	int i, ls;
	ls = atoi(valor);
	i=0,suma=0;

	while (i <= ls)
		suma += (i++);

	pthread_exit(0);
}

int main(int argc,char *argv[]){
	pthread_t tid;
	pthread_attr_t attr;

	if(argc != 2){
		fprintf(stderr, "Uso: ./pthread <entero>\n");
		return -1;
	}

	pthread_attr_init(&attr);
	pthread_create(&tid, &attr, mi_hilo, argv[1]);
	//pthread_join(tid,NULL);

	printf("Suma total: %d.\n",suma);

	return 0;
}
