#!/bin/bash
#Hola mundo
echo "Hola Mundo"

suma(){
valor1 = 1
valor2 = 2
echo $((valor1 + valor2))
}

#suma
sumaParametros(){
echo "Parametro 1:" $1
echo "Parametro 2:" $2 
echo $(($1 + $2))
}

#sumaParametros 1 2

echo "Escriba mensaje:"
read valor
echo $valor

usoDeFor(){
for((i=0;i<5;i++)) do
	echo $i
done
}

#usoDeFor

usoIf(){
read numero
if [[ $numero > 2 ]];then
echo "Es mas grande"
fi
}

#if,elif,else

#usoIf

crearArchivo(){
echo $numero >> salida.txt
}

#crearArchivo

