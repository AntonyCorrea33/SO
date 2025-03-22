#!/bin/bash

if [[ ! -f "administradores.txt" ]]; then  #Busca archivo y devuelve 0 o 1
	echo "Se creo archivo administradores"
	touch administradores.txt
	echo "admin-admin" > administradores.txt
fi

if [[ ! -f "clientes.txt" ]]; then 
	echo "Se creo archivo clientes"
	touch clientes.txt
fi

echo "Ingrese usuario: "
read usuario

echo "Ingrese contrasenia: "
read contrasenia

grep "^$usuario-$contrasenia$" administradores.txt > auxUsuario

if [[ -n "$auxUsuario" ]]; then #Se fija que no sea nula la variable
	echo "Se encontro administrador"
	echo "$auxUsuario"
else
	echo "No se encontro administrador"
	grep "^$usuario-$contrasenia$" clientes.txt > auxUsuario
fi

if [[ -n "$auxUsuario" ]]; then #Se fija que no sea nula la variable
	echo "Se encontro administrador"
	echo "$auxUsuario"
else
	echo "No se encontro cliente"
	menu
fi

menu(){
	echo "Hola"
}





