function getcpustat() {
	procstat=`cat /proc/stat | head -1`
	prev_user=`echo $procstat | awk '{print $2}'`
	prev_nice=`echo $procstat | awk '{print $3}'`
	prev_system=`echo $procstat | awk '{print $4}'`
	prev_idle=`echo $procstat | awk '{print $5}'`
	prev_iowait=`echo $procstat | awk '{print $6}'`
	prev_irq=`echo $procstat | awk '{print $7}'`
	prev_softirq=`echo $procstat | awk '{print $8}'`
	prev_steal=`echo $procstat | awk '{ print $9 }'`
	prev_guest=`echo $procstat | awk '{ print $10 }'`
	prev_guest_nice=`echo $procstat | awk '{ print $11}'`
	
	sleep $1
	
	procstat=`cat /proc/stat | head -1`
	user=`echo $procstat | awk '{print $2}'`
	nice=`echo $procstat | awk '{print $3}'`
	system=`echo $procstat | awk '{print $4}'`
	idle=`echo $procstat | awk '{print $5}'`
	iowait=`echo $procstat | awk '{print $6}'`
	irq=`echo $procstat | awk '{print $7}'`
	softirq=`echo $procstat | awk '{print $8}'`
	steal=`echo $procstat | awk '{ print $9 }'`
	guest=`echo $procstat | awk '{ print $10 }'`
	guest_nice=`echo $procstat | awk '{ print $11}'`
	
	prevIdle=`expr $prev_idle + $prev_iowait`
	idle=`expr $idle + $iowait`
	prevNonIdle=`expr $prev_user + $prev_nice + $prev_system + $prev_irq + $prev_softirq + $prev_steal`
	nonIdle=`expr $user + $nice + $system + $irq + $softirq + $steal`
	
	prevTotal=`expr $prevIdle + $prevNonIdle`
	total=`expr $idle + $nonIdle`
	
	totald=`expr $total - $prevTotal`
	idled=`expr $idle - $prevIdle`
	
	sub=`expr $totald - $idled`
	CPU_percentage=`awk "BEGIN {print ($sub / $totald) * 100}"`
	export CPU=$CPU_percentage
}

getcpustat 1
free_out=`free -m | grep Mem` 
used_ram=`echo $free_out| cut -f3 -d' '`
total=`echo $free_out | cut -f2 -d' '`
ram=$(echo "scale = 2; $used_ram/$total*100" | bc)
root_disk_usage=`df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`

if [ ! -e ./stats.csv ];then
	echo "DATE,CPU(%),HDD(%),RAM(%)" > ./stats.csv
fi

echo "$(date),$CPU,$root_disk_usage,$ram" >> ./stats.csv
