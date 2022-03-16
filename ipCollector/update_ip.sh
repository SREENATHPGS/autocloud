DAEMON_SERVER_URL=""
CUSTOM_DEVICE_NAME=""
SELECTED_INTERFACE=0

while getopts ":i:d:u:" opt; do
        case $opt in
                i)
                        #echo " -i was triggered, Parameter: $OPTARG" >&2
			if [ -z $OPTARG ];then
				echo "Interface not given. Exitting."
				exit
			fi
                        SELECTED_INTERFACE=$OPTARG
                ;;
		d)
			#echo " -d was triggered, Parameter: $OPTARG" >&2
			CUSTOM_DEVICE_NAME=$OPTARG
		;;
		u)
			#echo " -u was triggered, Parameter: $OPTARG" >&2
			if [ -z $OPTARG ];then
				echo "Daemon url not given. Exitting."
				exit
			fi
			DAEMON_SERVER_URL=$OPTARG
		;;
                ?/)
                        echo $opt
                        echo "Invalid option:"
                        exit 1
                ;;
                :)
                        echo $opt                        
                        echo "Option -$OPTARG requires an argument." >&2
                        exit 1
                ;;
        esac
done

if [ -z $CUSTOM_DEVICE_NAME ];then
	CUSTOM_DEVICE_NAME=`hostname`
	echo "Custom device name not given. Using hostname $CUSTOM_DEVICE_NAME."
fi


if [ -z $SELECTED_INTERFACE ] || [ -z $CUSTOM_DEVICE_NAME ] || [ -z $DAEMON_SERVER_URL ];then
	echo "Required parameters not given. Exitting.."
	exit
fi


function main() {

	export INTERNAL_IP_ADDRESS=$(ip address show $SELECTED_INTERFACE | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')

	if [ -z "$INTERNAL_IP_ADDRESS" ];then
		echo "Invalid IP address. Exitting."
		exit
	fi

	curl -X PATCH -i http://$DAEMON_SERVER_URL/myipis?ip=$INTERNAL_IP_ADDRESS\&device_id=$CUSTOM_DEVICE_NAME
}

main
