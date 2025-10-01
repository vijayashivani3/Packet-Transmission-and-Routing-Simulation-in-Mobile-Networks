
# NS2 Mobile Network Simulation - AODV Example
set ns [new Simulator]
set tracefile [open "trace_files/sample_aodv.tr" w]
$ns trace-all $tracefile
set namfile [open "nam_files/sample_aodv.nam" w]
$ns namtrace-all $namfile
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam nam_files/sample_aodv.nam &
    exit 0
}
set numNodes 10
for {set i 0} {$i < $numNodes} {incr i} {
    set node_($i) [$ns node]
}
$ns node-config -adhocRouting AODV -llType LL -macType Mac/802_11 -ifqType Queue/DropTail/PriQueue -ifqLen 50 -antType Antenna/OmniAntenna -propType Propagation/TwoRayGround -channelType Channel/WirelessChannel -agentTrace ON -routerTrace ON -macTrace ON
set maxX 500
set maxY 500
for {set i 0} {$i < $numNodes} {incr i} {
    $ns at 0.0 "$node_($i) set X_ [expr {rand()*$maxX}]"
    $ns at 0.0 "$node_($i) set Y_ [expr {rand()*$maxY}]"
}
set udp_ [new Agent/UDP]
$ns attach-agent $node_(0) $udp_
set null_ [new Agent/Null]
$ns attach-agent $node_(5) $null_
$ns connect $udp_ $null_
set cbr_ [new Application/Traffic/CBR]
$cbr_ set packetSize_ 512
$cbr_ set interval_ 0.1
$cbr_ attach-agent $udp_
$ns at 1.0 "$cbr_ start"
$ns at 20.0 "finish"
$ns run
