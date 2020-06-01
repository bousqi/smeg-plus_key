#!/bin/bash

STATUS=1
source /etc/feed_storage.config

function wait_server {
	printf "%s\n" "Waiting for [$HOST]"
#	while ! timeout 0.2 ping -c 1 -n $HOST &> /dev/null
	while ! ping -c 1 -n $HOST &> /dev/null
	do
		#printf "%c" "."
		sleep 5
	done
	printf "\n%s\n"  "Server is back online"
}

function mount_dirs {
	echo "Mounting remote"
	sudo umount -f /media/rpi
	mount /media/rpi
	echo "Mounting local MassStorage"
	sudo umount -f /media/c4pii
	sudo fsck -y /dev/mmcblk0p3
	mount /media/c4pii
}

function mount_RO_dirs {
	echo "Unmounting remote"
	sudo umount -f /media/rpi
	echo "Remounting local MassStorage"
	sudo mount -o remount,ro /media/c4pii
}

function check_media {
	if [ ! -d /media/rpi ]; then
		mkdir -p /media/rpi
	fi
}

function check_delta {
	echo "Checking for upgrade"
	if [ -d /media/rpi/mnt/papin.lan/freebox/eSata/SMEG+/_remote_c4/  ]; then
		UPDATE="1"
	else
		UPDATE="0"
	fi
}

function feed_maps {
	timeout 8 /usr/local/bin/notify "RPI-ZeroW" "Starting to feed..."
	rsync -avPzcv --stats --delete -e "ssh -p $PORT" $USER@$HOST:/mnt/papin.lan/freebox/eSata/SMEG+/_remote_c4/ /media/c4pii/
	sync

	# rsync -avP /media/rpi/media/freebox/eSata/SMEG+/_remote_c4/ /media/c4pii/ --delete
	STATUS=$?
	echo "LOG : rsync executed with $STATUS code"
	# if [ "$?" -eq "0" ]; then
	# 	STATUS=0/
	# 	# error during rsync... connection lost maybe...
	# 	# retry in few sec
	# 	sleep 5
	# 	STATUS=1
	# fi
}

check_media

wait_server
mount_dirs
check_delta

if [ "$UPDATE" -eq "1" ]; then
	sudo systemctl stop myusbgadget
	feed_maps
	if [ "$STATUS" -eq "0" ]; then
		mount_RO_dirs

		echo "Updates done"
		/usr/local/bin/notify "RPI-ZeroW" "Done !"

		# USB is ready, restoring USB Gadget
		sudo systemctl restart myusbgadget
	fi
else
	echo "No updates to perform"
	# exit 0
fi

