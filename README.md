# [photon](https://photonengine.com)-docker

This repository contains the configuration required to run [Exit Games' PhotonEngine](https://photonengine.com) server under Docker on a Linux host.

It *may* be unstable, you are on your own.

### Legal disclaimer
This project is not endorsed by Exit Games and does not reflect the views or opinions of Exit Games or anyone officially involved in producing or managing Exit Games properties.

## Building
The build process is fairly straightforward, albeit there are some caveats:
 - You **must** pre-configure most configuration values at build time.
 - Any IPs that are by default set to `0.0.0.0` **MUST** be changed. [[read more about this behavior]](#setting-ips)
 - Performance Counters **must be disabled**. They are not implemented under Wine, and will cause the service to crash. [[read more about this behavior]](#disabling-performance-counters)

To proceed with building the container, place the `deploy` folder of your Photon installation inside the `photon-server` directory, and run `docker build`

## Running
An example `docker-compose.yml` file is included in this repository. It is configured to accept `./photon.license` as the license file that will be passed onto Photon.

## Setting IPs
Due to a bug in an undetermined component (seems to be related to how the low-level C++ socket framework Photon uses binds to IPs), you are not able to bind to `0.0.0.0`. 

You will have to change the IP addresses to bind on by editing the `deploy/bin_Win64/PhotonServer.config` file.

Please be aware that the included `entrypoint.sh` script will automatically replace any IPs that point to `127.0.0.1` with the internal IP of the Docker container (fetched using `hostname -i`), and will also replace the GameServer's Public IP Address configuration with the `EXTERNAL_IP` environment variable.

## Disabling Performance Counters

Wine does not implement Windows Performance Counters, and as such, when Photon tries to register them, it crashes. The fix is to disable Performance Counters inside of Photon, which is hidden behind an **undocumented configuration option**.

In the LoadBalancing project, the `EnablePerformanceCounters` key has to be set under `configuration.Photon.LoadBalancing` for both the `MasterServer` and the `GameServer` as seen below:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <Photon>
    <LoadBalancing>
      <EnablePerformanceCounters>False</EnablePerformanceCounters>
      <GCLatencyMode>Interactive</GCLatencyMode>
    </LoadBalancing>
    ...
```

The same applies for the NameServer project, only replacing `LoadBalancing` with `NameServer` in the key path.