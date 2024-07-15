#cloudshell setup

#Install kubectl 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Now install eksctl and for that create a file named as eksctl.sh using nano or vi editor . 

#Copy the following content in that file 

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

# After copying the context change the mode of that file, use this command
   
chmod +x eksctl.sh

# Then run that script using this command
  
sudo sh eksctl.sh

# Check the installion 
  
eksctl version

#For creating eks cluster use following command change name, zone and node count according your requirement

eksctl create cluster --name my-eks-cluster --region us-east-1 --version 1.24 --nodegroup-name ng-1 --node-type t2.medium --nodes 1 --nodes-min 1 --nodes-max 5 --managed

# For deleting eks cluster

eksctl delete cluster --name my-eks-cluster --wait




