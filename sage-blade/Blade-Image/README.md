<!--
waggle_topic=IGNORE
-->

## A. Quick links, anywhere? 

Sure - [here](https://www.mcs.anl.gov/research/projects/waggle/downloads/beehive1/status_links.html)

## B. Beehive

### 1. How do I tell what data is flowing into beehive at this moment? 

#### Beehive data flow pipeline :

Currently, __all__ nodes use the v1 pipeline for coresense data. All newer plugins like image data or status data use v2.
They coexist, and v1 will be deprecated soon.

```
v1 pipeline ---> [ beehive-data-stream-v1 ] ---> Folder:datasets (workerbee)    -----+
                                                                                     + ---> digests
v2 pipeline ---> [ beehive-data-stream-v2 ] ---> Folder:datasets-v2 (workerbee) -----+
```
The scripts are available [here](https://github.com/waggle-sensor/beehive-server/tree/master/bin), they are installed on beehive. 

The columns are: 

__i. V1 pipeline hose__ - [beehive-data-stream-v1](https://github.com/waggle-sensor/beehive-server/blob/master/bin/beehive-data-stream-v1)
```
packet arrival timestamp,  sender id, packet timestamp, packet type, packet meta
```

__ii. V2 pipleline hose__ - [beehive-data-stream-v2](https://github.com/waggle-sensor/beehive-server/blob/master/bin/beehive-data-stream-v2)
```
packet timestamp, sender id, sender sub id, plugin id, plugin version, sensor id, parameter id, value raw
```

### 2. How do I tell how image and video samples are flowing into beehive at this moment?

The nodes that have image and audio samplers running on them store the samples in their local storage. A service running on Beehive takes those samples from the nodes and stores them temporally in Beehive. Then, it runs sanitization on those samples to filter out bad samples (e.g., samples without contents or samples with no interesting information in them). Fianlly, the "good" samples are then transferred into LCRC server for persistent storage. For illustration, see below

```
   [Waggle nodes]                [Beehive]                     [LCRC]
       samples      --rsync--     samples       --rsync-- sanitized samples
 in /wagglerw/files           in /storage/files           in designated path
                           {sanitization running}
```

Please look at `filesync.service` and `waggle-lcrc-transfer.timer` in Beehive for details. The rsync commands are running periodically and are configurable; the default is an hour.
