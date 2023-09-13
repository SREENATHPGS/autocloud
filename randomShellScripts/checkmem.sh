psinfo=$(ps -o pid,user,%mem,command ax | grep -v PID | sort -bnr -k3 | awk '/[0-9]*/{print $1 ":" $2 ":" $4}')

for process in $psinfo
do
	PID=$(echo $process | cut -d: -f1)
	OWNER=$(echo $process | cut -d: -f2)
	COMMAND=$(echo $process | cut -d: -f3)
	MEMORY=$(sudo pmap $PID | tail -n 1 | awk '/[0-9]K/{print $2}')

	echo "PID : $PID"
	echo "OWNER : $OWNER"
	echo "COMMAND : $COMMAND"
	echo "MEMORY : $MEMORY"
	echo ""
done
