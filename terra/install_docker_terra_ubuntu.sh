#!/bin/bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo "start " >> /a.txt
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "start 1" >> /a.txt
sudo apt-get update -y
echo "start 2" >> /a.txt
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "start 3" >> /a.txt
sudo groupadd docker
echo "1 " >> /a.txt
#sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu
echo "2 " >> /a.txt
sudo newgrp docker
#sudo apt-get install -y software-properties-common
#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
#sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#sudo apt-get update -y
#sudo apt-get install -y terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
echo "3 " >> /a.txt
sudo apt-get install terraform -y
sudo apt install unzip
echo "4 " >> /a.txt
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo "one " >> /home/ubuntu/a.txt
ls >> /home/ubuntu/a.txt
echo "5 " >> /a.txt
unzip awscliv2.zip
sudo ./aws/install
#-auto-approve
echo "6" >> /a.txt
#docker run -d -p 3000:3000 --name hostname-app adongy/hostname-docker:latest
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "7 " >> /a.txt
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
sudo apt-get update
sudo apt-get install -y kubectl
sudo apt-get install ec2-instance-connect -y
echo "8 " >> /a.txt
sudo apt install wireguard wireguard-tools resolvconf -y
echo "9 " >> /a.txt


echo "10 " >> /a.txt

cat <<EOF >output.txt
This is line 1.
This is line 2.
This is line 3.
EOF

sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sudo sysctl -p
echo "11 " >> /a.txt

sudo mkdir /etc/wireguard
sudo chmod 700 /etc/wireguard
echo "12 " >> /a.txt
# Generate server and client keys
SERVER_PRIVATE_KEY=$(wg genkey)
SERVER_PUBLIC_KEY=$(echo $SERVER_PRIVATE_KEY | wg pubkey)
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)
echo $SERVER_PRIVATE_KEY >>server_private_key.txt
echo $SERVER_PUBLIC_KEY >>server_public_key.txt
echo $CLIENT_PRIVATE_KEY >>client_private_key.txt
echo $CLIENT_PUBLIC_KEY >>client_public_key.txt


echo "12.1 " >> /a.txt
# Display the keys (optional)
echo "Server Private Key: $SERVER_PRIVATE_KEY"
echo "Server Public Key: $SERVER_PUBLIC_KEY"
echo "Client Private Key: $CLIENT_PRIVATE_KEY"
echo "Client Public Key: $CLIENT_PUBLIC_KEY"
echo "12.2 " >> /a.txt
# Create the WireGuard configuration file for the server
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 192.168.2.1/24
MTU = 1420
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY
SaveConfig = true
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostUp = iptables -A FORWARD -i eth0 -o wg0 -m state --state RELATED,ESTABLISHED
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i eth0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = 192.168.2.2/32
EOF
echo "12.3 " >> /a.txt
# Adjust firewall rules
ufw allow 51820/udp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 53/udp
sudo ufw allow 22/tcp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable
sudo ufw reload


# Start the WireGuard server
#wg-quick up wg0
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service

# Enable WireGuard to start on boot
#systemctl enable wg-quick@wg0
echo "12.4 " >> /a.txt

echo "12.5 " >> /a.txt

echo "13 " >> /a.txt