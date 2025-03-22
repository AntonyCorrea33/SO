#!/bin/bash

auxUsuario=""

menuCli(){
	echo "Bienvenido!"
	echo "Elija una opcion"
	echo "1)Listar Mascotas"
	echo "2)Adoptar Mascotas"
	echo "3)Salir"

	read opcion
}

menuAdm(){
	echo "Bienvenido!!"
	echo "Elija una opcion"
	echo "1)Registrar usuario"
	echo "2)Registrar mascota"
	echo "3)Estadisticas de adopcion"
	echo "4)Salir"

	read opcion
}

registroUsuario(){
	echo "Registro de Usuario"
	echo "Tipo de Usuario"
	echo "1)Administrador"
	echo "2)Cliente"
	read tipoUsuario
	echo "Ingrese nombre"
	read usuario
	echo "Ingrese cedula"
	read cedula
	echo "Ingrese numero de telefono"
	read numero
	echo "Ingrese fecha de nacimiento"
	read fecha
	echo "Ingrese contrasenia"
	read contrasenia

	auxUsuario="$usuario-$cedula-$numero-$fecha"
	echo "$auxUsuario"
	existe=$(grep "$auxUsuario" usuarios.txt)

	case "$tipoUsuario" in
		2)
		if [[ ! -n "$existe" ]]; then
			echo "$auxUsuario" >> usuarios.txt
			auxUsuario="$cedula-$contrasenia"
			echo "$auxUsuario" >> clientes.txt
		else
			echo "Ya existe este usuario"
			auxUsuario=""
		fi
		existe=""
		;;
		1)
		if [[ ! -n "$existe" ]]; then
			echo "$auxUsuario" >> usuarios.txt
			auxUsuario="$cedula-$contrasenia"
			echo "$auxUsuario" >> administradores.txt
		else
			echo "Ya existe este administrador"
			auxUsuario=""
		fi
		existe=""
		;;
		*)
			echo "Tipo invalido"
			existe=""
		;;
	esac

	menuAdm
}

registroMascota(){
	echo "Ingrese numero identificador"
	read numero
	if [[ ! "$numero" =~ ^-?[0-9]+$ ]]; then
		echo "Numero invalido"
		numero=""
		return
	fi
	echo "Ingrese tipo de mascota"
	read tipo
	echo "Ingrese nombre"
	read nombre
	echo "Ingrese sexo"
	read sexo
	echo "Ingrese edad"
	read edad
	if [[ ! "$edad" =~ ^[1-9][0-9]*$ ]]; then
		echo "Edad invalida"
		edad=""
		return
	fi
	echo "Ingrese descripcion"
	read descripcion
	fecha=$(date +%d/%m/%Y)
	auxMascota="$numero-$tipo-$nombre-$sexo-$edad-$descripcion-$fecha"
	echo "$auxMascota"
	existe=$(grep "$auxMascota" mascotas.txt)
	if [[ -n "$existe" ]]; then
		echo "Ya existe esta mascota"
	else
		echo "Se aniadio mascota"
		echo "$auxMascota" >> mascotas.txt
		existe=""
	fi

	menuAdm
}

estadisticasAdopcion(){
	awk -F '-' '{total++;count[$2]++;} END {for (type in count) printf "Tipo de mascota: %s, Porcentaje: %.2f%%\n", type, (count[type] / total) * 100;}' adopciones.txt
	awk -F '-' '{split($7, fecha, "/");mes[fecha[2]]++;} END {max = 0;for (m in mes) {if (mes[m] > max) {max = mes[m];mes_max = m;}}print "Mes con más adopciones:", mes_max, "Adopciones:", max;}' adopciones.txt
	awk -F '-' '{total_edad += $5;total_mascotas++;} END {print "Edad promedio de los animales adoptados:", total_edad / total_mascotas;}' adopciones.txt

	menuAdm
}

listarMascotas(){
	if [[ -s mascotas.txt ]];then
		awk -F '-' '{printf "%s - %s - %s - %s\n", $3, $2, $5, $6}' mascotas.txt
	else
		echo "No hay mascotas ingresadas"
	fi

	menuCli
}

adoptarMascota(){
	if [[ -s mascotas.txt ]];then
	        awk -F '-' '{printf "%s-%s \n", $1, $3}' mascotas.txt
		echo "Ingrese numero de mascota"
		read opcion
		mascota=$(grep "^$opcion-" mascotas.txt )

		if [[ -n "$mascota"  ]];then
			echo "Se encontro mascota"
			fecha=$(date +%d/%m/%Y)
			echo "$mascota-$fecha" >> adopciones.txt
			sed -i "/^$opcion\-/d" mascotas.txt
		else
			echo "Mascota no disponible"
		fi
        else
                echo "No hay mascotas ingresadas"
        fi

	menuCli
}

if [[ ! -f "usuarios.txt" ]]; then
	echo "Se creo archivo usuarios"
	touch usuarios.txt
fi

if [[ ! -f "mascotas.txt" ]]; then
	echo "Se creo archivo mascotas"
	touch mascotas.txt
fi

if [[ ! -f "adopciones.txt" ]]; then
	echo "Se creo archivo adopciones"
	touch adopciones.txt
fi

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

echo "$usuario-$contrasenia"
auxUsuario=$(grep "^${usuario}-${contrasenia}$" administradores.txt )

if [[ -n "$auxUsuario" ]]; then #Se fija que no sea nula la variable
	echo "Se encontro administrador"
	echo "$auxUsuario"
	menuAdm
	auxUsuario=""
	menu=2
else
	echo "No se encontro administrador"
	auxUsuario=$(grep "^${usuario}-${contrasenia}$" clientes.txt )
fi

if [[ -n "$auxUsuario" ]]; then #Se fija que no sea nula la variable
	echo "Se encontro usuario"
	echo "$auxUsuario"
	menuCli
	menu=1
else
	echo "No se encontro cliente"
fi

opcionMenu="$menu-$opcion"
echo "$opcionMenu"
case "$opcionMenu" in
	1-1)
		listarMascotas
	;;
	1-2)
		adoptarMascota
	;;
	1-3)
		exec "$0"
	;;
	2-2)
		registroMascota
	;;
	2-1)
		registroUsuario
	;;
	2-3)
		estadisticasAdopcion
	;;
	2-4)
		exec "$0"
	;;
	*)
		exec "$0"
	;;
esac

