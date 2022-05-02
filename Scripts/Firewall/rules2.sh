#!/bin/bash

# Criar Chains
iptables -N SSH
iptables -N DNS
iptables -N HTTP
iptables -N HTTPs
iptables -N LogAcceptSSH
iptables -N LogAcceptDNS
iptables -N LogAcceptHTTP
iptables -N LogAcceptHTTPs
iptables -N LogDrop

# Libera interface de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Entrada e Saída e log SSH
iptables -A INPUT  -p tcp --dport 22 -j SSH
iptables -A OUTPUT -p tcp --sport 22 -j SSH
iptables -A LogAcceptSSH -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service SSH]: " --log-level info
iptables -A SSH -j LogAcceptSSH
iptables -A SSH -j ACCEPT

# Entrada e Saída e log DNS
iptables -A INPUT -p tcp --dport 53 -j DNS
iptables -A OUTPUT -p tcp --sport 53 -j DNS
iptables -A LogAcceptDNS -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service DNS]: " --log-level info
iptables -A DNS -j LogAcceptDNS
iptables -A DNS -j ACCEPT

# Entrada e Saída e log HTTP
iptables -A INPUT -p tcp --dport 80 -j HTTP
iptables -A OUTPUT -p tcp --sport 80 -j HTTP
iptables -A LogAcceptHTTP -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTP]: " --log-level info
iptables -A HTTP -j LogAcceptHTTP
iptables -A HTTP -j ACCEPT

# Entrada e Saída e log HTTPs
iptables -A INPUT -p tcp --dport 443 -j HTTPs
iptables -A OUTPUT -p tcp --sport 443 -j HTTPs
iptables -A LogAcceptHTTPs -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTPs]: " --log-level info
iptables -A HTTPs -j LogAcceptHTTPs
iptables -A HTTPs -j ACCEPT

# Rejeitar e Registrar tráfego bloqueado
iptables -A INPUT -j LogDrop
iptables -A OUTPUT -j LogDrop
iptables -A LogDrop -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "Rejeitado: " --log-level info
iptables -A LogDrop -j DROP
