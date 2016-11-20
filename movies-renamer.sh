#!/usr/bin/env bash

# movies-renamer.sh
# Limpia los nombres de archivos de video de cadenas tipo 'XviD/[DivxTotal]/etc..'
# El archivo 'strings_cleanner_sed_list.sh' almacena todas las cadenas a modificar.
# Ambos archivos deben ubicarse en ~/bin para su correcto funcionamiento.

IFS=$'\n'
STRINGS="$HOME/bin/mr_sed_strings"
N='\033[00m'     # None
G='\033[01;32m'  # Green
R='\033[01;31m'  # Red
RU='\e[41m'      # Red Underlined

# confirma que estamos en el directorio donde se encuentran los archivos a modificar
function _correct_dir() {
	while :; do
	read -n1 -p $'Modificar archivos de video en \e[41m'${PWD}$'\e[0m [s/n]? ' dir
	echo ""
		case $dir in
			s|S) break ;;
			n|N) exit ;;
			*)  echo "Opcion no valida." ;;
		esac
	done
}

# imprime original y modificado sin alterar ningun archivo
function _test_rename() {
	local file
	for file in ${PWD}/*; do
		echo -e " ${file##*/}
		\r ${G}$(echo "${file##*/}" | sed -f "$STRINGS")${N}\n"
		sleep 0.1
	done
}

# renombra los archivos
function _all_rename() {
	local newtitle
	for file in ${PWD}/*; do
		newtitle="$(echo "${file##*/}" | sed -f "$STRINGS")"

		# si coinciden los nombres o es un dir. continua al siguiente
		if [[ "${file##*/}" == "$newtitle" || -d "$file" ]]; then
			continue
		else
			mv "${file}" "$newtitle"
		fi
	done
}

## MAIN ##

# si no se encuentra el archivo 'sed_cleaner_strings_mod' en $HOME/bin sale del script
[[ ! -f "$STRINGS" ]] && echo -e "El archivo ${RU}${STRINGS##*/}${N} no se encuentra en ~/bin." && exit

_correct_dir
_test_rename

while :; do
	read -p "[?] Continuar y renombrar los archivos [s/n]: " sino

	case $sino in
		[Ss])
			_all_rename
			break ;;
		[Nn])
			echo "[X] Renombrado de archivos cancelado."
			exit ;;
		*)
			echo -e "["${R}!${N}"] Opcion no valida inserte ["${G}S${N}"]i o ["${G}N${N}"]o :" ;;
	esac
done

echo -e "["${G}+${N}"] Renombrado de archivos finalizado."
