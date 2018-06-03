#!/bin/sh

####nr = la ligne qu'on va prende
####awk on travaille avec les colones
####ps -A -o pid, min_flt,maj_flt
### rss : donne l'utilisation de la mémoire physique en kilobyter par le process hors swap
### min_flt : nbr de page fault mineur
### max_flt : nbr de page fault majeur
### cpu : cpu usage
### %mem : memoire usage
### mem : voir la commande lancé
### rsz : taille de la mémoire virtuel
### sort -k 3trie sur la collone 3 qui est ici la charge cpu
NAME=$1
ORDER=$2
#echo $NAME
#echo $ORDER
proc(){
ps -eo user,pid,%cpu,%mem,rss,rsz,min_flt,maj_flt,command
}
boucle(){
i="0"
while [ $i -lt 2 ]
do
	free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
	sleep 1
	df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
	sleep 1
	top -bn1 | grep load 
	sleep 1
	free -m | awk 'NR==3{printf "Swap Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
	sleep 1 
	head -n 10 res.txt
 	sleep 3
	clear
	i=$((i+1))
done
}
while [ true ]
do
	if [ "$ORDER" = "DESC" ]
	then
		case $NAME in
			user)proc | sort -r -k 1 >res.txt ;;
			pid)proc | sort -r -n -k 2 >res.txt ;;
			%cpu)proc | sort -r -n -k 3 >res.txt ;;
			%mem)proc | sort -r -n -k 4 >res.txt;;
			rss)proc | sort -r -n -k 5 >res.txt ;;
			rsz)proc | sort -r -n -k 6 >res.txt ;;
			min_flt)proc | sort -r -n -k 7 >res.txt ;;
			maj_flt)proc | sort -r -n -k 8 >res.txt ;;
			command)proc | sort -r -d -k 9 >res.txt ;;
			*)proc | sort -r -k 3 >res.txt ;;
		esac
	boucle
	elif [ "$ORDER" = "ASC" ]
	then
		case $NAME in
			user)proc | sort -k 1 >res.txt ;;
			pid)proc | sort -n -k 2 >res.txt ;;
			%cpu)proc | sort -k 3 >res.txt ;;
			%mem)proc | sort -k 4 >res.txt ;;
			rss)proc | sort -n -k 5 >res.txt ;;
			rsz)proc | sort -n -k 6 >res.txt ;;
			min_flt)proc | sort -n -k 7 >res.txt ;;
			maj_flt)proc | sort -n -k 8 >res.txt ;;
			command)proc | sort -d -k 9 >res.txt ;;
			*)proc | sort -r -k 3 >res.txt ;;
		esac
	boucle
	else
		proc | sort -r -k 3 >res.txt
		boucle
	fi
done
### source ./exTP1