#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>

int v = 0;
sem_t mutex;

void* porDos(void * x){
	sem_wait(&mutex);
	v=v*2;
	printf("v = %d \n", v);
}

void* masUno (void * x){
	v++;
	printf("v = %d \n", v);
	sem_post(&mutex);
}

int main(){
	sem_init(&mutex, 0, 0);
	pthread_t t1,t2;
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_create(&t1, &attr, porDos, NULL);
	pthread_create(&t2, &attr, masUno, NULL);

	pthread_join(t1,NULL);
	pthread_join(t2,NULL);

	return 0;
}
