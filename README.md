# Sage Nodes

#### Lead(s): [Pete Beckman](mailto:beckman@anl.gov) and [Raj Sankaran](mailto:rajesh@anl.gov)

Any Edge node part of the Sage project is called a Sage Node.  This includes new AoT nodes, Wild Sage nodes, and Sage Blades. They 
are each built on the [Waggle AI@Edge Platform](https://github.com/waggle-sensor/waggle).

### Waggle Node:  
This slang indicates that an AI@Edge computer is running the Waggle software stack.  It is similar to saying “It’s a Linux Box”.  The Linux box could be running a web server or a database, but is running the core Linux software stack.  “A Waggle Node” runs the Waggle encrypted and reliable messaging layers, configuration system, resilience components, adheres to the Waggle security model, provides the AI@Edge runtime libraries, and provides the resource management components to schedule and run Edge docker containers from the Edge Code Repository. 
 
### Wild Sage Node:
This identifies Waggle Nodes that are weatherized for remote, outdoor deployment as part of the Sage project.  These nodes are similar to AoT nodes, but since urban aesthetics are not needed, and different cameras and sensors might be used, the Wild Sage Node may look strange.  Wild Sage Nodes look like proper bits of science experiments mounted outside, while AoT nodes look like they deserve an architectural award. 
 
### Sage Blade:
This identifies Waggle Nodes that are standard, commercially available blade server or box intended for use in a machine room or climate controlled telecommunications hut.  For the Sage project, the first Sage Blades are Dell XR2 1U servers that have been hardened for increased environmental range. They include a powerful NVIDIA GPU for AI@Edge compute jobs.  As a Waggle Node, they run the complete Waggle software stack, and therefore can run Edge jobs, report data, and be remotely configured.

### [Array of Things (AoT) Node](https://arrayofthings.github.io/):  
A weatherized Waggle Node designed to be installed on a street pole in the city or mounted on exterior walls.  An AoT node usually includes a sensor pod that includes air quality sensors.  The device is also attractive for an urban setting. 


## Nomenclature:
* **B1**: 19” HPE Rack-mounted node
* **S1**: Sage Version 1.0:  Current Waggle Node design with known modifications. 
* **S2.0**:  Sage Version 2.0:  First small batch 2.0 nodes.  Roughly 20% of build funds.
* **S2.1**:  Sage Version 2.1:  Production Sage nodes.2.0.

A “Wild Sage Node” has 1 CPU box, and one or more sensors.

## Sensors: 
 * POE Sensor Set
 * AoT Stevenson
 * Optional one external USB sensor

### Design Notes:

#### Components:
* New enclosure and mounting hardware
* NC: C2 Node Controller or similar
* EP: TX2 or similar
* POE + Edge-processor for Stevenson
* New Power Supply
* Include network adapter and external antenna mount
* Sensors: POE Cameras - Visual+Mic, FLIR

#### Boundary Interfaces:
* Weatherize connectors / External enclosure break for:
  - 1 X Ethernet (WAN)
  - 4 x RJ45: POE Sensors
  - 1 x USB3: Sensors
  - 1 x USB2 Slave: Console
  - 1 X AC Power (male)
* May include: 3-Color LED (clear weatherized bezel/dome)
* May include: Small momentary contact pushbutton switch

#### Custom Circuit Boards: 
 * [WagMan](https://github.com/waggle-sensor/wagman) V5
 * Stevenson sensor daughter board: Sound Level, Inertial, Pressure, Temp/RH (AoT Sensor Stack)
 
#### Mounting:
 * Internal mounts for all boards, heat sinks, power supplies
 * Interface for Wall or Pole mount
 * Custom Mounting:
  - Mount for Pole or Waggle Box
  - Carrier for METSense & Cameras
