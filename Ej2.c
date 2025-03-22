#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

#define NUM_MATERIAS 20

// Lista de materias y dependencias
const char *materias[] = {
    "IP", "M1", "F1", "ED", "M2", "F2", "PA", "BD", 
    "RC", "SO", "IS", "SI", "IA", "CG", "DW", "SD", 
    "BG", "RO", "CS", "AA"
};

int grafo[NUM_MATERIAS][NUM_MATERIAS] = {0}; // Matriz de adyacencia
int visitado[NUM_MATERIAS] = {0};
int orden[NUM_MATERIAS];
int indice = 0;

pthread_mutex_t lock;

void agregar_dependencia(int desde, int hacia) {
    grafo[desde][hacia] = 1;
}

void dfs(int nodo) {
    pthread_mutex_lock(&lock);
    if (visitado[nodo]) {
        pthread_mutex_unlock(&lock);
        return;
    }
    visitado[nodo] = 1;
    pthread_mutex_unlock(&lock);
    
    for (int i = 0; i < NUM_MATERIAS; i++) {
        if (grafo[nodo][i]) {
            dfs(i);
        }
    }

    pthread_mutex_lock(&lock);
    orden[indice++] = nodo;
    pthread_mutex_unlock(&lock);
}


void *ordenar(void *arg) {
    int nodo = *(int *)arg;
    dfs(nodo);
    return NULL;
}

void imprimir_orden() {
    printf("Orden de materias:\n");
    for (int i = indice - 1; i >= 0; i--) {
        printf("%s ", materias[orden[i]]);
    }
    printf("\n");
}



int main() {
    // Inicializar el grafo (Ejemplo: IP -> ED, IP = 0, ED = 3)
    agregar_dependencia(0, 3);  // IP -> ED
    agregar_dependencia(1, 4);  // M1 -> M2
    agregar_dependencia(2, 5);  // F1 -> F2
    agregar_dependencia(3, 6);  // ED -> PA
    agregar_dependencia(3, 7);  // ED -> BD
    agregar_dependencia(4, 6);  // M2 -> PA
    agregar_dependencia(4, 19);  // M2 -> AA
    agregar_dependencia(4, 12);  // M2 -> IA
    agregar_dependencia(4, 16);  // M2 -> Bid
    agregar_dependencia(5, 8);  // F2 -> RC
    agregar_dependencia(5, 13);  // F2 -> CG
    agregar_dependencia(5, 17);  // F2 -> RO
    agregar_dependencia(8, 9);  // RC -> SO
    agregar_dependencia(8, 14);  // RC -> DW
    agregar_dependencia(8, 11);  // RC -> SI
    agregar_dependencia(8, 15);  // RC -> SD
    agregar_dependencia(6, 9);  // PA -> SO
    agregar_dependencia(6, 10);  // PA -> IS
    agregar_dependencia(6, 13);  // PA -> CG
    agregar_dependencia(6, 8);  // PA -> RC
    agregar_dependencia(6, 12);  // PA -> IA
    agregar_dependencia(6, 16);  // PA -> Bid
    agregar_dependencia(6, 19);  // PA -> AA
    agregar_dependencia(6, 17);  // PA -> RO
    agregar_dependencia(7, 14);  // BD -> DW
    agregar_dependencia(7, 11);  // BD -> SI
    agregar_dependencia(11, 18);  // SI -> CS
    agregar_dependencia(9, 15);  // SO -> SD
    agregar_dependencia(9, 18);  // SO -> CS

    pthread_t threads[NUM_MATERIAS];

    // Crear threads para procesar cada nodo
    pthread_mutex_init(&lock, NULL);
    for (int i = 0; i < NUM_MATERIAS; i++) {
        int *nodo = malloc(sizeof(int));
        *nodo = i;
        pthread_create(&threads[i], NULL, ordenar, nodo);
    }

    // Esperar que los threads terminen
    for (int i = 0; i < NUM_MATERIAS; i++) {
        pthread_join(threads[i], NULL);
    }

    pthread_mutex_destroy(&lock);

    // Imprimir el orden
    imprimir_orden();
    return 0;
}
