set ns [new Simulator]
set f [open prg1out.tr w]
set nf [open prg1out.nam w]

$ns trace-all $f
$ns namtrace-all $nf

$ns color 1 "Blue"
$ns color 2 "Yellow"

proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
	exec nam prg1out.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n0 label "UDP src"
$n1 label "TCP src"
$n2 label "UDP & TCP Dest"

$ns duplex-link $n0 $n1 1.75Mb 10ms DropTail
$ns duplex-link $n1 $n2 2.75Mb 20ms DropTail
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient down

$ns queue-limit $n1 $n2 20

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set class_ 1

set cbro [new Application/Traffic/CBR]
$cbro attach-agent $udp0
$cbro set packetSize_ 500
$cbro set interval_ 0.005

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
$tcp0 set class_ 2

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set maxPkts_ 1000

set null0 [new Agent/Null]
$ns attach-agent $n2 $null0

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $udp0 $null0
$ns connect $tcp0 $sink

$ns at 0.5 "$cbro start"
$ns at 1.0 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.5 "$cbro stop"
$ns at 5.0 "finish"
$ns run
