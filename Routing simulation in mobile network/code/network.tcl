# Create simulator object
set ns [new Simulator]

# Define number of nodes
set val(nn) 5

# Create God instance to manage wireless topology
set god_ [create-god $val(nn)]

# Open trace and NAM files
set tracefile [open network.tr w]
$ns trace-all $tracefile

set namfile [open manet_out.nam w]
$ns namtrace-all-wireless $namfile 500 500

# Define wireless channel and create channel object explicitly
set val(chan) Channel/WirelessChannel
set chan_ [new $val(chan)]

# Other wireless parameters
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ll) LL
set val(ifq) Queue/DropTail/PriQueue
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(rp) AODV
set val(x) 500
set val(y) 500

# Create topology
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Node configuration, pass the channel object explicitly
$ns node-config -adhocRouting $val(rp) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channel $chan_ \
    -godInstance $god_ \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace ON

# Create nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0
}

# Set initial node positions
$node_(0) set X_ 100.0; $node_(0) set Y_ 100.0; $node_(0) set Z_ 0.0
$node_(1) set X_ 200.0; $node_(1) set Y_ 200.0; $node_(1) set Z_ 0.0
$node_(2) set X_ 300.0; $node_(2) set Y_ 300.0; $node_(2) set Z_ 0.0
$node_(3) set X_ 400.0; $node_(3) set Y_ 400.0; $node_(3) set Z_ 0.0
$node_(4) set X_ 500.0; $node_(4) set Y_ 500.0; $node_(4) set Z_ 0.0

# Attach UDP agent to node 0 (source)
set udp [new Agent/UDP]
$ns attach-agent $node_(0) $udp

# Attach Null agent to node 4 (sink)
set null [new Agent/Null]
$ns attach-agent $node_(4) $null

# Connect UDP and Null agents
$ns connect $udp $null

# Create and configure CBR traffic
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.1    ;# Sends 10 packets/sec
$cbr attach-agent $udp

# Schedule traffic start and stop
$ns at 1.0 "$cbr start"
$ns at 4.5 "$cbr stop"

# Schedule node 0 mobility
$ns at 1.0 "$node_(0) setdest 400.0 400.0 10.0"

# Define finish procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam manet_out.nam &
    exit 0
}

# Schedule simulation end
$ns at 6.0 "finish"

# Run simulation
$ns run

