#!/bin/bash

# Desativar forward
sysctl -w net.ipv4.ip_forward=0

# Zerar log iptables
echo -n > /var/log/iptables.log

# Limpar todas regras
iptables -F

# Removendo Chains
iptables -X

# Zerar contador
iptables -Z

# Libera trafego para todas poli­ticas
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
