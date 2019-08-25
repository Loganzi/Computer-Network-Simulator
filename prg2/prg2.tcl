set ns [new Simulator]

set f [open prg2out.tr w]
set nf [open prg2out.nam w]

$ns trace-all $f
$ns namtrace-all $nf

$ns color 1 "Blue"
$ns color 2 "Yellow"
$ns color 3 "Red"
$ns color 4 "Green"

proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
	exec nam prg2out.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 2Mb 10ms DropTail 

$ns duplex-link-op $n0 $n2 orient right-up
$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down
$ns queue-limit $n2 $n3 10

set ping0 [new Agent/Ping]
set ping1 [new Agent/Ping]
set ping4 [new Agent/Ping]
set ping5 [new Agent/Ping]

$ping0 set class_ 1
$ping1 set class_ 2
$ping4 set class_ 3
$ping5 set class_ 4

$ns attach-agent $n0 $ping0
$ns attach-agent $n1 $ping1
$ns attach-agent $n4 $ping4
$ns attach-agent $n5 $ping5

$ns connect $ping0 $ping5
$ns connect $ping1 $ping4
$ns connect $ping4 $ping0
$ns connect $ping5 $ping1

proc sendPack {} {
	global ns ping0 ping1 ping4 ping5
	set pinginterval 0.01
	set now [$ns now]
	puts "$now and $pinginterval"
	$ns at $now "$ping0 send"
	$ns at $now "$ping1 send"
	$ns at $now "$ping4 send"
	$ns at $now "$ping5 send"
	$ns at [expr $now + $pinginterval] "sendPack"
}

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] received ping ans from $from with RTT $rtt ms."
}

$ns at 0.01 "sendPack"

$ns rtmodel-at 3.0 down $n2 $n3
$ns rtmodel-at 5.0 up $n2 $n3

$ns at 10.0 "finish"
$ns run
