
#!/bin/bash


ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

#eksctl variables
#=================
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

#Installing Terraform
#====================================================================

yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

VALIDATE $? "Installing terraform"

# growpart /dev/nvme0n1 4
# lvextend -L +20G /dev/RootVG/rootVol
# lvextend -L +10G /dev/RootVG/homeVol

# xfs_growfs /
# xfs_growfs /home

#Installing Docker
#====================================================================
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

VALIDATE $? "Installing Docker"

#Installing eksctl
#====================================================================
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

VALIDATE $? "Installing eksctl"


#Installing kubectl
#====================================================================
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl

VALIDATE $? "Installing kubectl"

eksctl version
kubectl version


#Installing kubens
#====================================================================
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

VALIDATE $? "Installing kubens"

#Installing Helm
#====================================================================
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

VALIDATE $? "Installing Helm"