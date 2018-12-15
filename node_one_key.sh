#!/bin/sh
if [ $# -lt 1 ]; then
    echo '缺少参数, 格式 sh node_one_key.sh <新的host名>'
    exit 1
fi
yum install -y docker
systemctl start docker
systemctl enable docker.service
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet
echo 'before set host...'
hostnamectl --static set-hostname  $1
sed -i '$a\127.0.0.1 '$1 /etc/hosts
modprobe br_netfilter
sysctl net.bridge.bridge-nf-call-iptables=1
echo 'all done'

