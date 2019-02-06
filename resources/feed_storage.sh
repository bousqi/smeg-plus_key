#!/bin/bash

AGAIN=1
HOST=bousquet.freeboxos.fr

function wait_server {
	printf "%s\n" "Waiting for [bousquet.freeboxos.fr]"
#	while ! timeout 0.2 ping -c 1 -n $HOST &> /dev/null
	while ! ping -c 1 -n $HOST &> /dev/null
	do
		#printf "%c" "."
		sleep 5
	done
	printf "\n%s\n"  "Server is back online"
}

function mount_server {
	echo "Mounting remote"
	sudo umount -f /media/rpi
	mount /media/rpi
	echo "Mounting local MassStorage"
	sudo umount -f /media/c4pii
	mount /media/c4pii
}

function check_media {
	if [ ! -d /media/rpi ]; then
		mkdir -p /media/rpi
	fi
}

function check_delta {
	echo "Checking for upgrade"
	if [ -d /media/rpi/media/freebox/eSata/SMEG+/_remote_c4/  ]; then
		UPDATE="1"
	else
		UPDATE="0"
	fi
}

function feed_maps {
	timeout 8 /usr/local/bin/notify "RPI-ZeroW" "Starting to feed..."
	rsync -avP /media/rpi/media/freebox/eSata/SMEG+/_remote_c4/ /media/c4pii/ --delete
	AGAIN=$?
	# if [ "$?" -eq "0" ]; then
	# 	AGAIN=0
	# else
	# 	# error during rsync... connection lost maybe...
	# 	# retry in few sec
	# 	sleep 5
	# 	AGAIN=1
	# fi
}

check_media

while [ ! "$AGAIN" -eq "0" ]; do
	wait_server
	mount_server
	check_delta

	if [ "$UPDATE" -eq "1" ]; then
		sudo systemctl stop myusbgadget
		feed_maps
	else
		echo "No updates to perform"
		exit 0
	fi
done

echo "Updates done"
/usr/local/bin/notify "RPI-ZeroW" "Done !"
# USB is ready, restoring USB Gadget
sudo systemctl restart myusbgadget
