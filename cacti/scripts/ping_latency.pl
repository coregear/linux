#!/usr/bin/perl

$Target = $ARGV[0]; 
$PLCount = 12; 

$Ping = "ping -l 3 -c $PLCount -i .2 -w 2 $Target |"; 

open(PING, $Ping) || die "U:U\n"; 
while(<PING>) {
        #64 bytes from 192.168.3.1: icmp_seq=3 ttl=254 time=16.0 ms
	if(/time=(\d+\.?\d*)\sms/) {
		if($1 eq "<") {push(@RTValues, 0)} 
                else {push(@RTValues, $1)} 
                $PLCount--;
	} 
} 
close(PING); 

#Calculate the Average Round-Trip Time 
@RTValues = sort {$a <=> $b} @RTValues;         #Sorts the numbers 
shift(@RTValues);                               #Removes the lowest number 
pop(@RTValues);                                 #Removes the highest number 

$Average = $Average / ($#RTValues + 1);
while($i <= $#RTValues) {
        $Average += $RTValues[$i];
        $i++; 
} 

$Average = $Average / $#RTValues; 
$Average = sprintf("%.0f", $Average);           #Round Off Decimals 

#Calculate the Packet Loss Percentage 
$PacketLoss = $PLCount * 5; 
if($PacketLoss == 100) {$Average = "U"} 

print "roundtrip:$Average packetloss:$PacketLoss"; 
