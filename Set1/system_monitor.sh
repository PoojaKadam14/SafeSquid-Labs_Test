#!/bin/bash

# Interval for refreshing dashboard
INTERVAL=5

# Function to get top 10 most used applications by CPU and memory
get_top_apps() {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 11
    echo ""
}

# Function for network monitoring
get_network_stats() {
    echo "Network Monitoring:"
    echo "Concurrent Connections:"
    netstat -an | grep ESTABLISHED | wc -l
    echo "Packet Drops:"
    netstat -s | grep "packet loss"
    echo "Network Traffic (MB):"
    ifstat -i eth0 1 1 | awk '{print "In: "$1" KB/s, Out: "$2" KB/s"}'
    echo ""
}

# Function for disk usage
get_disk_usage() {
    echo "Disk Usage:"
    df -h | awk '{if($5+0 > 80) print "Warning: "$0; else print $0}'
    echo ""
}

# Function for system load
get_system_load() {
    echo "System Load:"
    uptime
    echo "CPU Usage Breakdown:"
    mpstat | grep "all"
    echo ""
}

# Function for memory usage
get_memory_usage() {
    echo "Memory Usage:"
    free -h
    echo ""
}

# Function for process monitoring
get_process_monitoring() {
    echo "Process Monitoring:"
    echo "Number of Active Processes:"
    ps aux | wc -l
    echo "Top 5 Processes by CPU and Memory:"
    ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 6
    echo ""
}

# Function for service monitoring
get_service_monitoring() {
    echo "Service Monitoring:"
    services=("sshd" "nginx" "apache2" "iptables")
    for service in "${services[@]}"; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
    echo ""
}

# Full dashboard view
show_dashboard() {
    clear
    echo "System Resource Dashboard"
    echo "-------------------------"
    get_top_apps
    get_network_stats
    get_disk_usage
    get_system_load
    get_memory_usage
    get_process_monitoring
    get_service_monitoring
}

# Handle command line switches for specific sections
while getopts "t,n,d,l,m,p,s,a" opt; do
  case $opt in
    t)
      get_top_apps
      ;;
    n)
      get_network_stats
      ;;
    d)
      get_disk_usage
      ;;
    l)
      get_system_load
      ;;
    m)
      get_memory_usage
      ;;
    p)
      get_process_monitoring
      ;;
    s)
      get_service_monitoring
      ;;
    a)
      show_dashboard
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  exit 0
done

# Run the dashboard in a loop if no switches are provided
while true; do
    show_dashboard
    sleep $INTERVAL
done
