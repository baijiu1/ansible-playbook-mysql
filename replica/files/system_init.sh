#!/bin/bash
function system_init(){
function ulimits(){
cat > /etc/security/limits.conf <<EOF
* soft noproc 65536
* hard noproc 65536
* soft nofile 65536
* hard nofile 65536
EOF

echo > /etc/security/limits.d/20-nproc.conf 

ulimit -n 65536
ulimit -u 65536

}

function kernel(){
cat > /etc/sysctl.conf <<EOF
fs.file-max = 65536
net.core.netdev_max_backlog = 32768
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.somaxconn = 32768
net.core.wmem_default = 8388608
net.core.wmem_max = 16777216
net.ipv4.conf.all.arp_ignore = 0
net.ipv4.conf.lo.arp_announce = 0
net.ipv4.conf.lo.arp_ignore = 0
net.ipv4.ip_local_port_range = 5000 65000
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
sysctl -p >/dev/null 2>&1
}

function history(){
	if ! grep "HISTTIMEFORMAT" /etc/profile >/dev/null 2>&1
	then echo '
	UserIP=$(who -u am i | cut -d"("  -f 2 | sed -e "s/[()]//g")
	export HISTTIMEFORMAT="[%F %T] [`whoami`] [${UserIP}] " ' >> /etc/profile;
	fi
	sed -i "s/HISTSIZE=1000/HISTSIZE=999999999/" /etc/profile
}

function security(){
	> /etc/issue
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0 >/dev/null 2>&1
	yum install -y openssl openssh bash >/dev/null 2>&1
}

function other(){
	yum groupinstall Development tools -y >/dev/null 2>&1
	yum install -y vim wget lrzsz telnet traceroute iotop tree git >/dev/null 2>&1
	echo "export HOME=/root" >> /etc/profile
	source /etc/profile
	useradd -M -s /sbin/nologin nginx >/dev/null 2>&1
	mkdir -p /root/ops_scripts /data1/www
	mkdir -p /opt/codo/
}

export -f ulimits
export -f kernel
export -f history
export -f security
export -f other

ulimits
kernel
history
security
other
}
