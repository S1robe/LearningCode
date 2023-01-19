#!/bin/bash

# Date: 1/18/23
# Desc: Practice with various output formatting tools, files, and methods
# Assign: Bash Lab

if test -n "$1" ;
then

 if [ $1 == 'sys' ];
 then
  echo -------------------------------System Information----------------------------
  echo -e "Hostname:\t\t$(hostname)"
  echo -e "uptime:\t\t\t$(uptime --pretty | sed 's/up //')"
  
  echo -e "Manufacturer:\t\t$(cat /sys/class/dmi/id/board_vendor)"
  echo -e "Product Name:\t\t$(cat /sys/class/dmi/id/board_name)"
  echo -e "Version:\t\t$(cat /sys/class/dmi/id/board_version)"
  vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo -e "Machine Type:\t\tVM"; else echo -e "Machine Type:\t\tPhysical"; fi 
  
  echo -e "Operating System:\t$(uname -o)"
  echo -e "Kernel:\t\t\t$(uname -r)"
  echo -e "Architecture:\t\t$(uname -m)"
  
  echo -e "Processor Name:\t\t$(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//' )"
  echo -e "Active User:\t\t$(id -un)"
  echo -e "Main System IP:\t\t$(hostname -i)"

 # ./sysInfo mem -> Memory info
 elif [ $1 == 'mem' ];
 then
  echo -------------------------------CPU/Memory Usage------------------------------

  # awk assigns the first 7 things it sees to $1-7, i print these in same order with spaces limited
  echo -e "$(free | awk '{printf("%s %s %s %s %s %s %s\n"),$1,$2,$3,$4,$5,$6,$7}')\n"

  # print the line that contains "Mem" formatting the equation (3rd arg/(2nd * 100)) as a float and to 2 decimals
  echo -e "Memory Usage:\t$(free | awk '/Mem/{printf("%.2f%%"), $3/$2*100}')"

  # grab line starting with "Swap", perform same calc, format as float and print 2 dec places
  echo -e "Swap Usage:\t$(free | awk '/Swap/{printf("%.2f%"),$3/$2*100}')"

  # cat procstat to stdout, and format equation
  echo -e "CPU Usage:\t$(cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' | awk '{print $0}' | head -1)"

 elif [ $1 == 'disk' ];
 then
  echo -------------------------------Disk Usage------------------------------------
  # Disk Usage %
  df -h | awk '$NF=="/"{printf "Disk Usage: %s\t\t\n\n", $5}'

  # print disk usage stats /w mount points, if the mount is longer than 80 char, print FS
   df -Ph | sed 's/Use%/Use /'
  # favoring this one till told otherwise, much cleaner
  #df -Ph | sed 's/%//' | awk '{printf("%s %s %s %s %s %s %s\n"),$1,$2,$3,$4,$5,$6,$7}'

 else
   echo Error, invalid parameter.
 fi

else
  echo Usage: sysInfo "<sys|mem|disk>"
fi
