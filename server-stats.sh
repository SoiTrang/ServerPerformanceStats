#!/bin/bash
echo -e "\n--- Total CPU Usage ---"
top -bn1 | grep "%Cpu(s)" | awk '{usage = 100 - $8} END {printf "CPU Usage: %.2f%%\n", usage}'
echo -e "\n--- Memory Usage ---"
free -m | awk 'NR==2{
    total=$2; used=$3; free=$4;
    printf "Total: %d MB\nUsed: %d MB\nFree: %d MB\nUsage: %.2f%%\n",
           total, used, free, (used/total)*100
}'
echo -e "\n--- Disk Usage ---"
df -h --total | grep 'total' | awk '{ 
    printf "Used: %s / Total: %s (%s used)\n", $3, $2, $5
}'
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo -e "\n--- OS Version ---"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo -e "\n--- Uptime ---"
uptime -p
echo -e "\n--- Load Average ---"
uptime | awk -F'load average:' '{ print $2 }'
echo -e "\n--- Logged In Users ---"
who | wc -l
echo -e "\n--- Failed Login Attempts (last 24h) ---"
journalctl _COMM=sshd --since "24 hours ago" | grep "Failed password" | wc -l
