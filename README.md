# Cluster Swarm com Vagrant

Este projeto cria um **cluster Docker Swarm** usando 4 máquinas virtuais com Vagrant, organizadas em subpastas para cada node:

- **master**: nó manager
- **node01**, **node02**, **node03**: nós workers

## Estrutura de Pastas

swarm-vagrant/
│
├── master/
│ ├── Vagrantfile
│ └── provision.sh
│
├── node01/
│ ├── Vagrantfile
│ └── provision.sh
│
├── node02/
│ ├── Vagrantfile
│ └── provision.sh
│
├── node03/
│ ├── Vagrantfile
│ └── provision.sh
│
└── README.md

yaml
Copiar código

---

## 1️⃣ Script de Provisionamento (`provision.sh`)

Este script instala o Docker em cada VM:

```bash
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
2️⃣ Vagrantfile de Cada Máquina
master/Vagrantfile
ruby
Copiar código
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "master"
  config.vm.network "private_network", ip: "192.168.56.10"
  config.vm.provision "shell", path: "provision.sh"
end
node01/Vagrantfile (node02 e node03 seguem o mesmo modelo)
ruby
Copiar código
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "node01"
  config.vm.network "private_network", ip: "192.168.56.11"
  config.vm.provision "shell", path: "provision.sh"
end
3️⃣ Subindo as VMs
Dentro de cada subpasta:

bash
Copiar código
cd master
vagrant up

cd ../node01
vagrant up

cd ../node02
vagrant up

cd ../node03
vagrant up
4️⃣ Inicializando o Swarm
Na VM master:

bash
Copiar código
vagrant ssh master
docker swarm init --advertise-addr 192.168.56.10
Isso vai gerar um comando como:

bash
Copiar código
docker swarm join --token SWMTKN-1-xxxxxxxx 192.168.56.10:2377
5️⃣ Adicionando os Workers
Em cada worker:

bash
Copiar código
vagrant ssh node01
docker swarm join --token SWMTKN-1-xxxxxxxx 192.168.56.10:2377
Repita para node02 e node03.

6️⃣ Verificando o Cluster
Na master:

bash
Copiar código
docker node ls
Você deve ver:

mathematica
Copiar código
ID                            HOSTNAME            STATUS    AVAILABILITY   MANAGER STATUS
abcd1234                      master              Ready     Active        Leader
efgh5678                      node01              Ready     Active
ijkl9012                      node02              Ready     Active
mnop3456                      node03              Ready     Active
