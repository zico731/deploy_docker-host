#!/bin/bash

###########################################################
#
#   Description déploiement à la volée de conteneur docker
#
#   Auteur :  Xavier
#
#   Date : 28/12/2018   Edité : le 27/9/2021 
#
############################################################


# si option --create
if [ "$1" == "--create" ];then

	# définition du nombre de conteneur	
	nb_machine=1
	[ "$2" != "" ] && nb_machine=$2
	
	# setting min/max
	min=1
	max=0

	# récupération de idmax
	idmax=`docker ps -a --format '{{ .Names}}' | awk -F "-" -v user=$USER '$0 ~ user"-alpine" {print $3}'| sort -rn|head -1`
	
	# redéfinition de min et max
	min=$(($idmax + 1))
	max=$(($idmax + $nb_machine))

	# création des conteneurs
	echo "Début de la création du/des conteneurs..."
	for i in $(seq $min $max);do
		docker run -tid --name $USER-alpine-$i alpine:latest
		echo "Conteneur $USER-alpine-$i crée"
	
	done
	
# si option --drop
elif [ "$1" == "--drop" ];then
	
	echo "Suppression des conteneurs..."
	docker rm -f $(docker ps -a | grep $USER-alpine | awk '{print $1}')
	echo "Fin de la suppression"

# si option --start
elif [ "$1" == "--start" ];then
	echo ""
	echo " notre option est --start"
	docker start $(docker ps -a | grep $USER-alpine | awk '{print $1}')
	echo ""
	

# si option --infos
elif [ "$1" == "--infos" ];then
	
	echo ""
	echo "Informations des conteneurs :"
	for conteneur in $(docker ps -a | grep $USER-alpine | awk '{print $1}'); do
		docker inspect -f ' => {{.Name}} - {{.NetworkSettings.IPAddress }}' $conteneur
	done
	echo ""

else 
	echo "Voici les differentes options à mettre après deploy :"
	echo "  --create <nb>"
	echo "  --drop"
	echo "  --start"
	echo "  --infos"
	echo "  --ansible"
	

fi
