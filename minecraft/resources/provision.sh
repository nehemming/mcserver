#!/bin/sh
set -v +e

#Wait for the server to be available from clound init etc.
echo "Starting fuser, waiting for server to be ready"
while fuser /var/lib/apt/lists/lock >/dev/null; do sleep 1; done

echo "Setting timezone"
timedatectl set-timezone ${server_timezone}

echo "Running update"
apt-get update

echo "Running install of new packages"
apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    ufw \
    jq \
    fail2ban

apt-get install -y unattended-upgrades

echo "Doing upgrade of all packages"
export DEBIAN_FRONTEND=noninteractive
yes '' | apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade

echo "Setup firewall"
ufw --force reset

# open ssh
ufw allow ssh

# open mc server port
ufw allow ${minecraft_public_port}/tcp

if [ "$minecraft_enable_rcon" == "true" ]; then
echo "Allowing RCON traffic ${minecraft_rcon_public_port}"
ufw allow ${minecraft_rcon_public_port}
fi

ufw default deny incoming

# blocks go here
ufw --force enable
ufw status verbose

echo "Firewall done"

echo "Install docker"
 
#possibly iptables-persistent

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

wget "https://github.com/bcicen/ctop/releases/download/v0.7.5/ctop-0.7.5-linux-amd64"  -O /usr/local/bin/ctop

chmod +x /usr/local/bin/ctop

echo "Docker Installed"