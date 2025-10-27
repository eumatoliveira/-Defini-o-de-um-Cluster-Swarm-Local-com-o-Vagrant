#!/bin/bash
# Atualiza pacotes
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona chave do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona repositório Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instala Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Permite usar Docker sem sudo
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo systemctl start docker
