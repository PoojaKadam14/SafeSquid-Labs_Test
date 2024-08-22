#!/bin/bash

# Users and Group Audit
audit_users_and_groups() {
    echo "== User and Group Audit =="
    cat /etc/passwd | awk -F: '{print $1, $3, $6}'
    grep ':x:0:' /etc/passwd
}

# File and Directory Permissions
audit_file_permissions() {
    echo "== File and Directory Permissions =="
    find / -perm -0002 -type f -exec ls -l {} \;
    find / -perm /6000 -type f
    find /home -name ".ssh" -exec chmod 700 {} \;
}

# Services Audit
audit_services() {
    echo "== Services Audit =="
    systemctl list-units --type=service --state=running
    netstat -tuln
}

# Firewall and Network Security
audit_firewall_and_network() {
    echo "== Firewall and Network Security =="
    iptables -L
    ss -tuln
}

# IP and Network Configuration
audit_ip_configuration() {
    echo "== IP and Network Configuration =="
    ip a
}

# Security Updates and Patches
check_security_updates() {
    echo "== Checking for Security Updates =="
    apt-get upgrade --dry-run | grep security
}

# Log Monitoring
check_logs() {
    echo "== Log Monitoring =="
    grep "Failed password" /var/log/auth.log | tail -n 20
}

# Server Hardening
hardening_ssh() {
    echo "== SSH Hardening =="
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    systemctl restart sshd
}

# Reporting
generate_report() {
    echo "== Generating Report =="
    # Combine all output into a single report file
}

# Main function to run checks
run_audit() {
    audit_users_and_groups
    audit_file_permissions
    audit_services
    audit_firewall_and_network
    audit_ip_configuration
    check_security_updates
    check_logs
    generate_report
}

run_audit
