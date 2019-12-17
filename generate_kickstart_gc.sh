#!/usr/bin/env bash

# This file will create an ISO with a kickstart to be used to bootstrap
# UCS Blades at Livingston International.

# Prerequisits:
# Grab the ISO from VMWare
# Mount the ISO to /mnt/temp0
# `rsync -a /mnt/temp0/ /tmp/esxi/`

# The files which need to be edited in case of newer ESXi Versions are:
# /etc/boot.cfg           # Append $kernelopt=$kernelopt ks=cdrom:/KS_CUST.CFG
# /etc/efi/boot/boot.cfg  # Append $kernelopt=$kernelopt ks=cdrom:/KS_CUST.CFG

# Variables
TEMPLATE=$1
COUNT=1
BLADE_HOSTNAME_PREFIX="hyp"
BLADE_NUM=98
CIDR=172.16.1

# Render a templated kickstart file.
# Expand variables + preserve formatting.
# Referenced inside the template.txt as $user
# render_template /path/to/template.txt > path/to/configuration_file
generateKickstart() {
  mkdir /usr/share/nginx/html/ks/$BLADE_HOSTNAME
  eval "echo \"$(cat $1)\"" > /usr/share/nginx/html/ks/$BLADE_HOSTNAME/index.html
}

generateNginx() {
  eval "echo \"$(cat $1)\"" > /etc/nginx/default.d/$BLADE_HOSTNAME.conf
  sudo systemctl reload nginx
}

work() {
  until [ $COUNT -eq 0 ]; do
    local BLADE_HOSTNAME=$BLADE_HOSTNAME_PREFIX$BLADE_NUM
    generateKickstart $TEMPLATE
    generateNginx nginx.tmpl
    let COUNT--
    let BLADE_NUM++
  done
}

work
