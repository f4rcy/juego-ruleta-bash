#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl C
function ctrl_c(){
        echo -e "\n\n${redColour}[x] Saliendo...${endColour}\n"
        tput cnorm && exit 1
}

trap ctrl_c INT

# funciones

function panel(){
	echo -e "\n${yellowColour}[-] ${grayColour} Ayuda: ${purpleColour}$0${endColour}\n"
	echo -e "\t${blueColour}m) ${grayColour} Dinero con el que deseas jugar.${endColour}"
	echo -e "\t${blueColour}t) ${grayColour} Tecnica con la que vas a jugar.${endColour} (${yellowColour}martingala${endColour}/${yellowColour}labouchereR${endColour})"
}

function martingala(){
	echo -e "\n${greenColour}[-] ${grayColour} Dinero actual: $money${endColour}"
	echo -ne "${greenColour}[-] ${grayColour} Cuanto dinero quieres apostar? -> ${endColour}" && read apostar
	echo -ne "${greenColour}[-] ${grayColour} A qué vas apostar continuamente? (${yellowColour}par${endColour}/${yellowColour}impar${endColour}) -> ${endColour}" && read par_impar

	echo -e "\n${greenColour}[-] ${grayColour} Vamos a jugar con una cantidad de ${yellowColour}$apostar ${grayColour}a ${yellowColour}$par_impar${endColour}\n"

	backup_apostar=$apostar
	contador=1
	jugadas_malas=" "

	tput civis
	while true; do

		money=$(($money - $apostar))
		#echo -e "\n${greenColour}[-] ${grayColour} Vas apostar ${yellowColour}$apostar${grayColour}, ahora tienes ${yellowColour}$money${endColour}"
		random="$(($RANDOM % 37))"
		#echo -e "${greenColour}[-] ${grayColour} Ha salido el numero -> ${yellowColour}$random${endColour}"

		if [ ! "$money" -lt 0 ]; then
			if [ "$par_impar" == "par" ]; then
				# CUANDO ELEGIMOS APOSTAR A PAR
				if [ "$(($random % 2))" -eq 0 ]; then
					if [ "$random" -eq 0 ]; then
						# 0
						# echo -e "${greenColour}[-] ${grayColour} El numero que ha salido es 0, perdiste :(${endColour}"
						apostar=$(($apostar*2))
						jugadas_malas+="$random "
						# echo -e "${greenColour}[-] ${grayColour} Ahora tienes ${yellowColour}$money${endColour}"
					else
						# par, ganas
						# echo -e "${greenColour}[-]  El numero que ha salido es par ¡GANAS!${endColour}"
						recompensa=$(($apostar*2))
						# echo -e "${greenColour}[-] ${grayColour} Ganaste ${yellowColour}$apostar${endColour}"
						money=$(($money + $apostar))
						# echo -e "${greenColour}[-] ${grayColour} Ahora tienes ${yellowColour}$money${endColour}"
						apostar=$backup_apostar
						jugadas_malas+=""
					fi
				else
					# impar, pierdes
					# echo -e "${greenColour}[-] ${redColour} El numero que ha salido es impar ¡PIERDES! ${endColour}"
					apostar=$(($apostar*2))
					jugadas_malas+="$random "
					# echo -e "${greenColour}[-] ${grayColour} Ahora tienes ${yellowColour}$money${endColour}"
				fi
			else
				# CUANDO ELEGIMOS IMPAR
				if [ "$(($random % 2))" -eq 1 ]; then
					# echo -e "${greenColour}[-]  El numero que ha salido es impar ¡GANAS!${endColour}"
					recompensa=$(($apostar*2))
					# echo -e "${greenColour}[-] ${grayColour} Ganaste ${yellowColour}$apostar${endColour}"
					money=$(($money + $apostar))
					# echo -e "${greenColour}[-] ${grayColour} Ahora tienes ${yellowColour}$money${endColour}"
					apostar=$backup_apostar
					jugadas_malas+=""
				else
					apostar=$(($apostar*2))
					jugadas_malas+="$random "
					# echo -e "${greenColour}[-] ${grayColour} Ahora tienes ${yellowColour}$money${endColour}"
				fi
			fi
		else
			echo -e "\n${redColour}[-] Te quedaste sin dinero D:${endColour}\n"
			echo -e "${greenColour}[-] ${grayColour} Han habido un total de ${yellowColour}$(($contador-1))${grayColour} jugadas.${endColour}"
			echo -e "\n${greenColour}[-] ${grayColour} Malas jugadas que te han salido: ${endColour}\n"
			echo -e "${yellowColour}[ $jugadas_malas ]${endColour}\n"
			tput cnorm; exit 0
		fi

		let contador+=1
		
	done
}

function labouchere(){

	echo -e "\n${greenColour}[-] ${grayColour} Dinero actual: $money${endColour}"
	echo -ne "${greenColour}[-] ${grayColour} A qué vas apostar continuamente? (${yellowColour}par${endColour}/${yellowColour}impar${endColour}) -> ${endColour}" && read par_impar

	declare -a secuencia=(1 2 3 4)

	echo -e "\n${greenColour}[-] ${grayColour} Comenzamos con la secuencia [${yellowColour}${secuencia[@]}${endColour}]\n"

	apuesta=$((${secuencia[0]} + ${secuencia[-1]}))

	jugadas=0

	tput civis
	while true; do
		let jugadas+=1
		random="$(($RANDOM % 37))"
		if [ ! "$money" -lt 0 ]; then
			money=$(($money - $apuesta))

			echo -e "${greenColour}[-] ${grayColour} Invertimos ${yellowColour}$apuesta${endColour}"
			echo -e "${greenColour}[-] ${grayColour} Ahora tenemos ${yellowColour}$money${endColour}\n"

			echo -e "${greenColour}[-] ${grayColour} Ha salido el numero ${yellowColour}$random${endColour}"
		
			#CUANDO QUEREMOS APOSTAR A PAR
			if [ "$par_impar" == "par" ]; then
				if [ "$(($random % 2))" -eq 0 ] && [ "$random" -ne 0 ]; then #-ne es que no es igual a 0.
					#GANAMOS
					echo -e "${greenColour}[-]  El numero que ha salido es par ¡GANAS!${endColour}"

					recompensa=$(($apuesta*2))
					money=$(($money + $recompensa))

					echo -e "${greenColour}[-] ${grayColour} has ganado ${yellowColour}$recompensa${grayColour}, ahora tienes ${yellowColour}$money${endColour}"

					secuencia+=($apuesta)
					secuencia=(${secuencia[@]})

					echo -e "${greenColour}[-] ${grayColour} Nuestra nueva secuencia es [${yellowColour}${secuencia[@]}${endColour}]"
					if [ "${#secuencia[@]}" -ne 1 ]; then 
						apuesta=$((${secuencia[0]} + ${secuencia[-1]}))
					elif [ "${#secuencia[@]}" -eq 1 ]; then
						apuesta=${secuencia[0]}
					else
						echo -e "${redColour} Hemos perdido nuestra secuencia.${endColour}"
						secuencia=(1 2 3 4)
						echo -e "${greenColour}[-] ${grayColour} Restablecemos la secuencia a [${yellowColour}${secuencia[@]}${endColour}]"
					fi

				elif [ "$random" -eq 0 ]; then
				#PERDEMOS SALE 0
					echo -e "${redColour}[-] El numero que ha salido es 0 ¡PIERDES! ${endColour}\n"
				elif [ "$(($random % 2))" -eq 1 ] || [ "$(($random % 2))" -eq 0 ]; then
				if [ "$(($random % 2))" -eq 1 ]; then
					echo -e "${redColour}[-] El numero que ha salido es impar ¡PIERDES! ${endColour}\n"
				else
					echo -e "${redColour}[-] El numero que ha salido es 0 ¡PIERDES! ${endColour}\n"
				fi

					unset secuencia[0]
					unset secuencia[-1] 2>/dev/null
					secuencia=(${secuencia[@]})

					echo -e "${greenColour}[-] ${grayColour} La secuencia nos queda de la siguiente forma [${yellowColour}${secuencia[@]}${endColour}]"
					if [ "${#secuencia[@]}" -ne 1 ] && [ "${#secuencia[@]}" -ne 0 ]; then 
						apuesta=$((${secuencia[0]} + ${secuencia[-1]}))
					elif [ "${#secuencia[@]}" -eq 1 ]; then
						apuesta=${secuencia[0]}
					else
						echo -e "${redColour}[x] Hemos perdido nuestra secuencia.${endColour}\n"
						secuencia=(1 2 3 4)
						echo -e "${greenColour}[-] ${grayColour} Restablecemos la secuencia a [${yellowColour}${secuencia[@]}${endColour}]"
						apuesta=$((${secuencia[0]} + ${secuencia[-1]}))
					fi
				fi
			fi
		else
			echo -e "\n${redColour}[-] Te quedaste sin dinero D:${endColour}\n"
			echo -e "${greenColour}[-] ${grayColour} Han habido un total de ${yellowColour}$jugadas${grayColour} jugadas.${endColour}"
			tput cnorm; exit 1
		fi
		#sleep 3
	done
	tput cnorm
}

while getopts "m:t:h" arg; do
	case $arg in
	m) money=$OPTARG;;
	t) tecnica=$OPTARG;;
	h) ;;
	esac
done

if [ "$money" ] && [ "$tecnica" ]; then
	if [ "$tecnica" == "martingala" ]; then
	martingala
	elif [ "$tecnica" == "labouchereR" ]; then
	labouchere
	else
	echo -e "\n${redColour}[x] Tecnica no encontrada${redColour}"
	panel
	fi
else
	panel
fi
