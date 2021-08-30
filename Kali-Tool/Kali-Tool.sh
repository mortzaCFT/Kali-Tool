#!/bin/bash
# Kali-Tool (thank you Ömer Doğan ) | Coded by mortza

#check source files
source /usr/share/Kali-Tool/config > /dev/null || { clear;echo -e "\e[31m [-] FATAL ERROR: MAIN CONFIG COULD NOT BE SOURCED!\e[0m";exit 1;}

banner
# run with a root privilege
[ $UID != 0 ]  && err "Kali-Tool must be run as root. ${GREEN}'sudo $(basename ${0})'${RESET}" 

src_check() {

        check_status="1"
        for i in $(seq 1 ${#}) ; do
                if [ -f $SRCDIR/sources/${@:i:1} ];then
			source $SRCDIR/sources/${@:i:1} 
		else
			warn "The source file could not be found. Please re-install the tool. (Module: ${@:i:1})"
			check_status="0"
                fi
        done
        if [ "${check_status}" = "0" ] ; then
                err "Please run this command:\n'${GREEN}git clone https://github.com/Pxmortza/Kali-Tool && cd Kali-Tool && sudo make reinstall${RESET}'"
        fi
}
src_check fix log_killer ip_changer dns_changer mac_changer anti_cold_boot hostname_changer timezone_changer Fake_AP

#check dependences function
dep_check() {
        check_status="1"
        for i in $(seq 1 ${#}) ; do
                [ $(command -v ${@:i:1}) ] || { warn "${@:i:1}: could not be found." ; check_status="0" ; }
        done
        if [ "${check_status}" = "0" ] ; then
                err "Please run this command: '${GREEN}sudo apt update && sudo apt install tar tor curl python3 python3-scapy network-manager${RESET}'"
        fi
}

start(){

#check dependences
dep_check tar tor curl python3 scapy

#get a backup to fix it in case of a possible error 
if [ ! -f $BACKUPDIR/tool_fix_backups.tar.gz ]; then
	get_backups
fi

options=("Log killer" "Ip changer" "Dns changer" "Mac changer" "Timezone changer" "Hostname changer"  "Anti cold boot" "Fake_AP")

menu() {
    info "Avaliable features:\n"
    for opt in ${!options[@]}; do
        printf "[%s] %s\n" $((opt+1)) "${options[opt]} ${choices[opt]}"
    done
    [[ "$stat" ]] && msg "$stat"; :
}
 
while banner && menu && input && read -r num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { stat="Invalid option: $num"; continue; }
    ((num--)); stat="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="✓"
done
banner
#detect selected features and run
for opt in ${!options[@]}; do


	for st in $(seq 0 $(( ${#options[@]} - 1 ))) ; do
	  if [[ "${choices[opt]}" ]] && [[ "${options[opt]}" == ${options[st]} ]]; then
		 $(echo start_${options[st]} | sed -e 's/ /_/g;s/\(.*\)/\L\1/;s/ı/i/g')
	  fi
	done

done

}

stop(){

#detect enable features and stop
if $(cat $SRCDIR/sources/config | grep Enable &>/dev/null);then

	options=("anti_mitm" "ip_changer" "dns_changer" "mac_changer" "timezone_changer" "hostname_changer" "Fake_AP" )


	}

	for st in $(seq 0 $(( ${#options[@]} - 1 ))) ; do
	  status="${options[st]}_status"
	  if [[ ${!status} == "Enable" ]] ; then
		stop_${options[st]}
	  fi
	done

else
	err "No features are active. (Run to activate '${GREEN}sudo Kali-Tool --start${RESET}')"
fi
}

status(){

msg "Kali-Tool status:

 ${GREEN}Ip changer            :${RESET} $ip_changer_status
 ${GREEN}Dns changer           :${RESET} $dns_changer_status
 ${GREEN}Mac changer           :${RESET} $mac_changer_status
 ${GREEN}Timezone changer      :${RESET} $timezone_changer_status
 ${GREEN}Hostname changer      :${RESET} $hostname_changer_status
 ${GREEN}Fake AP               :${RESET} $fakeap_status

}

fix(){

#repair system with backups received for a possible bug 
if [ -f $BACKUPDIR/tool_fix_backups.tar.gz ]; then
	restore_system
	msg "System successfully repaired"
else
	err "Kali-Tool backup file not found"
fi
}

help() {


msg "Usage : sudo Kali-Tool ${GREEN}[option]${RESET}
 ${GREEN}--start  :${RESET}   It will make backups and start the program.
 ${GREEN}--stop   :${RESET}   Closes the program using a backup.
 ${GREEN}--status :${RESET}   Provides information about IP address and working status.
 ${GREEN}--fix    :${RESET}   Used to repair the system in case of a possible bug.
 ${GREEN}--help   :${RESET}   This shows the menu."
}

main() {

if [[ "$#" -eq 0 ]]; then
    warn "tool: Argument required"
    info "Run ${GREEN}'Kali-Tool --help'${RESET} for more information."
    exit 1
fi

    case "$1" in
    --[sS][tT][aA][rR][tT]|-[sS][tT])
        start   
        ;;
    --[sS][tT][oO][pP]|-[sS][pP])
        stop    
        ;;
    --[sS][tT][aA][tT][uU][sS]|-[sS][sS])
        status  
        ;;
    --[fF][iI][xX]|-[fF])
        fix  
        ;;
    --[hH][eE][lL][pP]|-[hH])
        help
        exit 1
        ;;
    *)
          warn "tool: Invalid option ${RED}'$1'${RESET}"
          info "Run ${GREEN}'Kali-Tool --help'${RESET} parameter for more information."
          exit 1
        ;;
    esac
}


# call main
main "${@}"

# EOF


