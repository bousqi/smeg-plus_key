#!/bin/bash

cp /usr/local/src/psakey/build_eem.sh .
cp /usr/local/src/psakey/resources/bridge_enable.sh resources/
cp /usr/local/src/zerow_feed/feed_storage.service resources/
cp /usr/local/src/zerow_feed/feed_storage.sh resources/
cp /usr/local/bin/myusbgadget resources/
cp /usr/lib/systemd/system/myusbgadget.service resources/
cp /usr/local/bin/usbgadget_disable.sh resources/
cp /usr/local/bin/usbgadget_enable.sh resources/

