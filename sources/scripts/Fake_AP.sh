# FakeAP
start_Fake_AP()
{
if [[ "$Fake_AP_status" == "Disable" ]]; then

source /usr/share/Kali-Tool/sources/config

# backup mac addresses
	if [ ! -d $BACKUPDIR/Fake_AP ];then
		mkdir $BACKUPDIR/Fake_AP
	fi
	IFACES=$(ip -o link show | awk -F': ' '{print $2}')
	    for IFACE in $IFACES; do
		if [ $IFACE != "lo" ]; then
		    cat /sys/class/net/$IFACE/address > $BACKUPDIR/Fake_AP/$IFACE
		fi
	    done

function askAP {
		
	DIGITOS_WIFIS_CSV=`echo "$Host_MAC" | wc -m`
	
	if [ $DIGITOS_WIFIS_CSV -le 15 ]; then
		selection && break
	fi
	
	if [ "$(echo $WIFIDRIVER | grep -i 8187)" ]; then
		fakeapmode="airbase-ng"
		askauth
	fi
	
	mostrarheader
	while true; do
		
		infoap
		
		echo "MODE FakeAP"
		echo "                                       "
		echo -e "      "$green "1)"$transparent" Hostapd ("$red"Recommend)"$transparent")"
		echo -e "      "$green "2)"$transparent" airbase-ng (Slower connection)"
		echo -e "      "$green "3)"$transparent" Back"
		echo "                                       "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) fakeapmode="hostapd"; authmode="handshake"; handshakelocation; break ;;
			2 ) fakeapmode="airbase-ng"; askauth; break ;;
			3 ) selection; break ;;
			* ) echo "Unknown option. Choose again"; conditional_clear ;;
		esac
	done 
	
} 

#restore backups and stop service
stop_mac_changer(){

	source /usr/share/Kali-Tool/sources/config
	
	for device in $(ls $BACKUPDIR/fake_ap) ; do
	    ip link set $device down
	    ip link set $device address $(cat $BACKUPDIR/fake_ap/$device)
	    ip link set $device up
	done
	rm -fr $BACKUPDIR/backups/fake_ap && sed -i 's/fake_ap_status="Enable"/fake_ap_status="Disable"/g' $SRCDIR/sources/config
	info "fake_ap successfully disabled"

}

