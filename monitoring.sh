#!bin/bash

#Arquitectura y version kernel
sok=$(uname -a)
printf "#Architecture: %s\n" "$sok"

#Numero de nucleos fisicos
nf=$(lscpu |grep Socket | awk '{print $2}')
printf "#CPU physical : %s\n" "$nf"

#Numero de nucleos virtuales
nv=$(nproc)
printf "#vCPU : %s\n" "$nv"

#RAM disponible y porcentaje de uso
memU=$(free -m | grep Mem | awk '{print $3}')
memT=$(free -m | grep Mem | awk '{print $2}')
porc=$(free -m | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')
printf "#Memory Usage: $memU/$memT%s ($porc%%)\n" "MB"

#Memoria disponible y porcentaje de uso
memU=$(df -h --block-size=M --total | grep total | awk '{print $3}' | cut -d 'M' -f1)
memT=$(df -h --block-size=G --total | grep total | awk '{print $2}' | cut -d 'G' -f1)
porc=$(df -h --block-size=G --total | grep total | awk '{print $5}' | cut -d '%' -f1)
printf "#Disk Usage: $memU/$memT%s ($porc%%)\n" "Gb"

#Porcentaje actual uso nucleos
p1=$(mpstat | grep all | awk '{print $NF}')
p1=$(echo "$p1" | tr ',' '.')
p1=$(echo "100 - $p1" | bc)
p1=$(echo "$p1" | tr '.' ',')
printf "#CPU load: %01.2f%s\n" $p1 "%"

#Fecha y hora del ultimo reinicio
date=$(who -b | awk '{print $4 " " $5}')
printf "#Last boot: $date\n"

#LVM activo?
num=$(lsblk | grep "lvm" | wc -l)
printf "#LVM use: "
if [ $num -gt 0 ]
then
        printf "yes\n"
else
        printf "no\n"
fi

#Numero conexiones activas
numTCP=$(ss -t state established | wc -l)
printf "#TCP Connections: %d ESTABLISHED\n" "$((numTCP - 1))"

#Numero usuarios del servidor
numU=$(who | wc -l)
printf "#User log: $numU\n"

#Direccion ipv4 y MAC
ip=$(hostname -I)
mac=$(ip link | grep link/ether | awk '{print $2}')
printf "#Network: IP %s(%s)\n" "$ip" "$mac"

#Numero comandos ejecutados con sudo
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
printf "#Sudo : $sudo %s\n" "cmd"