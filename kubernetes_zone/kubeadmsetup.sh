# installation of docker and K8s 

curl -fsSL https://get.docker.com -o /tmp/install-docker.sh
sh /tmp/install-docker.sh
sudo usermod -aG docker ubuntu
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb



# after this become a sudo user and add CRI (on Linux Machine Master node) any one of the following
# for cri-dockerd
kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock


# install CNI plugin on the Master node to communicate with the nodes
kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.29/net.yaml


# after CRI and CNI installation add other node by performing suggested commands

# you can join any number of worker nodes by running the suggested command(root user)
# while executing join add the cri socket(--cri-socket) which is used in the master
