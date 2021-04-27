#!/bin/bash


# usage
# set flag m (1-3) to:
#	1 - nmap service and versions scan,
#		dirsearch if there is a webservice
#		traceroute
# set flag h to set the host you wanna scan,
# set flag v (1-3) to set the verbosity of the scans output
# set flag a (1-3) to set the aggressivity level of scans

## colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

helpMessage="${red}aloo alooooooo help message alooooooOOOO${reset}"

#default values
aggressive=0
mode=1

# get option flags
while getopts "Hh:v:a:m:" option
do
	case $option in
		m)
			mode=$OPTARG
			;;
		v)
			verbose=$OPTARG
			;;
		a)
			aggressive=1
			;;
		h)
			host=$OPTARG
			;;
		H)
			echo $helpMessage
			exit
			;;
	esac
done

startingMessage="you are going to scan: ${yellow}$host${reset}\naggressivity: ${yellow}$aggressiveValue${reset}\nwith a level ${yellow}$verbose${reset} of verbosity\n\n${red}Starting in 3 seconds ... ${reset}"

echo -e $startingMessage

# wait 3 seconds
# sleep 3

# Nmap flags based on aggressivity value
case $mode in
	1)
		;;
	2)
		nmapFlags="-sC -sV"
		;;
	3)
		echo "3"
		;;
esac

# Start nmap
echo -e "\n${green}[+] Open ports:${reset}"
openPorts=`nmap $host | grep open | cut -d"/" -f1`
echo $openPorts

# Service scan with retrieved ports
echo -e "\n${yellow}[i] starting service and version scan ...${reset}"
 nmap -sC -sV -p`echo $openPorts | sed 's/ /,/g'` $host
echo -e "${green}[+] Service scan completed.${reset}"

# Traceroute
echo -e "\n${yellow}[i] Starting traceroute...${reset}"
tracerouteOutput=`traceroute $host`
if [ `echo $tracerouteOutput | wc -l` -eq 0 ]
then
	# no output, print error
	echo "${red}[!] no Traceroute output${reset}"
else
	# print traceroute output
	echo $tracerouteOutput
	echo -e "${green}[+] Traceroute completed.${reset}"
fi

# +short flag to be removed on verbose output
echo -e "\n${yellow}[i] Starting dig reverse lookup ...${reset}"
digOutput=`dig -x $host +short`

if [ `echo $digOutput | sed -r '/^\s*$/d' | wc -l` -eq 0 ]
then
	# no output, print error
	echo "${red}[!] no Dig output${reset}"
else
	# print Dig output
	echo $digOutput
	echo "${green}[+] Dig completed"
fi

