This guide will let you make an Raspberry Pi Zero W act like a wifi hotspot to connect to 
SMEG+ Unit, but also make a smart usb mass storage with automatic feed feature (for ZAR/Maps)<br>
SMEG+ Key embeds :
* CDC_EEM Gadget
* MassStorage Gadget
* MassStorage feeding mechanism to download contents to MS luns
* Wifi Hotspot (TODO)


This project is based on the huge work acheived by [@MWyann](https://github.com/Mwyann) on PSAKey

Quick install from scratch
==========================

- Download and install latest raspbian stretch lite on a sdcard: https://www.raspberrypi.org/downloads/raspbian/
- Start your RPi with HDMI and a keyboard plugged in via USB OTG
- Connect with user "pi" and password "raspberry" (beware non-QWERTY keyboards)
- Execute `sudo raspi-config`, and follow these steps:
  - Update raspi-config
  - Localisation Options > Change Keyboard Layout > Choose your keyboard layout
  - Network > Wifi > Enter SSID/passphrase
  - Change password (recommended)
  - Boot Options > Wait for Network > No
  - Interfacing > SSH > Yes
  - Advanced > Expand
  - Advanced > Memory Split > 16
  - Finish and reboot the RPi
- Grab the RPi's Wifi IP and make sure you can connect to it with SSH, like `ssh pi@192.168.0.20`
- Once connected to SSH:
  - `sudo apt-get update`
  - `sudo apt-get upgrade`
  - `sudo apt-get install git`
  - `git clone https://github.com/bousqi/smeg-plus_key.git`
  - `cd smeg-plus_key`
  - `sudo bash install_smegkey.sh`
  - `poweroff`
- Plug the RPi's Micro-USB connector (data, not power) on your car using a standard Micro-USB cable.


More information
================

Before installation
-------------------

This script will enable the USB gadget feature on the Raspberry Pi, thus it will disable the standard USB OTG.
If you wish to connect to the Raspberry while it's plugged into your car (for testing purposes or anything), you should
configure the WLAN by filling the `/etc/wpa_supplicant/wpa_supplicant.conf` file correctly.

If you forgot to do this after running the installation script, you have two options to get back into your RPi:
- Remove the SD card, put it into another Linux computer, mount the root partition and make the changes.
- Connect the RPi into another Linux computer, you'll see an usb0 connection showing. Configure it to be IP 192.168.0.1
  (for example `ifconfig usb0 192.168.0.1`) and then `ssh pi@192.168.0.2`.

Installation
------------

The `install_smegkey.sh` script will take care of all the configuration you need to get you started with your PSA key installation.
You can configure the path of the root of the PSAKEY website that will be served to your car by editing the install script
and changing the `PSAKEYROOT` variable at the top.

After installation
------------------

When installation is done, you can reboot your RPi to make all changes active. Please note that the script configures the
sdcard partitions to be read-only because the RPi will be powered off by losing power when operated on the car, so to avoid filesystem
corruption, I force a read-only mounting, and I specify some directories to be mounted as tmpfs (on RAM).
If you need to remount read-write, you can run the `remount` script (installed in /usr/sbin/) and it will remount the
root filesystem as read-write for you. Don't forget to power off or reboot your Rpi properly to avoid problems.

If your SMEG+ displays the Hello World test correctly, then congratulations, you're good to go!
You can now write HTML code for your car to display, just edit the PSAKEYROOT/index.html file on your key.

Updating kernel
---------------

If you want to update to the latest supported kernel, just run the update_kernel.sh script.


Building the usb_f_eem module
-----------------------------

If the usb_f_eem module is missing for your kernel, you can automatically build the module from your device with **build_eem.sh**<br>
The on device build procedure downloads the current running kernel sources, enables EEM features, build it and installs it.
More details in [build_eem.sh](./build_eem.sh)

## Links
* https://github.com/Mwyann/psakey
* https://github.com/notro/rpi-source/wiki
* https://wiki.tizen.org/USB/Linux_USB_Layers/Configfs_Composite_Gadget/Usage_eq._to_g_multi.ko
