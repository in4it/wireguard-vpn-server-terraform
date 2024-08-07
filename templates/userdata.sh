#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install binutils -y

# reinitialize vpn
systemctl stop vpn-rest-server
systemctl stop vpn-configmanager
wg-quick down vpn
rm -rf /vpn/config
rm -rf /vpn/secrets
rm -rf /vpn/tls-certs

# efs helper
cd /root
git clone https://github.com/aws/efs-utils
cd efs-utils
git checkout v1.36.0
# patch depreciation warning
wget https://patch-diff.githubusercontent.com/raw/aws/efs-utils/pull/217.patch
patch -p1 < 217.patch
# end patch
./build-deb.sh
mv ./build/amazon-efs-utils*deb /
apt-get -y install /amazon-efs-utils*deb
rm /amazon-efs-utils*deb

# set mounts in fstab
echo -e "${efs_fs_id}\t/efs\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/config\t/vpn/config\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/secrets\t/vpn/secrets\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/tls-certs\t/vpn/tls-certs\tefs\t_netdev,noresvport,tls" >> /etc/fstab

# require mounts before starting the vpn server
sed -i 's#\[Unit\]#[Unit]\nRequires=vpn-config.mount vpn-secrets.mount\nAfter=vpn-config.mount vpn-secrets.mount#' /etc/systemd/system/vpn-configmanager.service
sed -i 's#\[Unit\]#[Unit]\nRequires=vpn-config.mount vpn-secrets.mount\nAfter=vpn-config.mount vpn-secrets.mount#' /etc/systemd/system/vpn-rest-server.service

# reload systemd
systemctl daemon-reload

# create directories and mount
mkdir -p /efs
mount /efs
mkdir -p /efs/config
mkdir -p /efs/secrets
mkdir -p /efs/tls-certs
chown vpn:vpn /efs/config
chown vpn:vpn /efs/tls-certs
chmod 700 /efs
chmod 700 /efs/config
chmod 700 /efs/tls-certs
chmod 700 /efs/secrets

mkdir /vpn/config
mount /vpn/config
mkdir /vpn/secrets
mount /vpn/secrets
mkdir /vpn/tls-certs
mount /vpn/tls-certs

# restart vpn
systemctl start vpn-rest-server
systemctl start vpn-configmanager
