set -e
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down || true
ifconfig flannel.1 down || true
ifconfig docker0 down || true
ip link delete cni0 || true
ip link delete flannel.1 || true
systemctl start docker
