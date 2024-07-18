# Install eksctl using chocolately
choco install eksctl

# Then download the latest release of eksctl
# Use this link to get latest release 
https://github.com/eksctl-io/eksctl/releases/tag/v0.186.0

# After that choose the release that you want
https://github.com/eksctl-io/eksctl/releases/download/v0.186.0/eksctl_Windows_amd64.zip

#Extract the ZIP file and add the eksctl.exe executable to your system's PATH. 

#Verify the installation by running:
 
eksctl version

# Use this command for create eks cluster 
 
eksctl create cluster --name my-eks-cluster --region us-east-1 --version 1.24 --nodegroup-name ng-1 --node-type t2.medium --nodes 2 --nodes-min 1 --nodes-max 5 --managed

# For deleting cluster 

eksctl delete cluster --name my-eks-cluster --wait
