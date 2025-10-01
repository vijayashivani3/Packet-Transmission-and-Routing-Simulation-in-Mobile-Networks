# Packet Transmission and Routing Simulation in Mobile Networks

## Overview
This project simulates packet transmission and routing in a mobile wireless network using **NS2 (Network Simulator 2)**. The simulation demonstrates how nodes communicate using **AODV routing protocol** with **UDP traffic** and mobile node movement. It also visualizes network activity using **NAM** and generates trace files for analysis.

Key features:
- Mobile nodes in a wireless network topology.
- AODV (Ad hoc On-Demand Distance Vector) routing protocol.
- UDP-based CBR (Constant Bit Rate) traffic generation.
- Node mobility and destination-based movement.
- Trace files for packet-level analysis.
- Visualization through NAM (Network Animator).

---

## Topology & Setup
- **Number of nodes:** 5
- **Simulation area:** 500m x 500m
- **Node placement:** Initial coordinates manually set
- **Routing protocol:** AODV
- **MAC protocol:** 802.11
- **Propagation model:** TwoRayGround
- **Queue type:** DropTail/Priority Queue
- **Traffic type:** CBR over UDP (10 packets/sec, 512 bytes/packet)
- **Node mobility:** Node 0 moves from (100,100) to (400,400) at 10 m/s

---

## Files
- `network.tcl` – NS2 simulation script.
- `network.tr` – Trace file generated during simulation.
- `network.nam` – NAM file for network visualization.


