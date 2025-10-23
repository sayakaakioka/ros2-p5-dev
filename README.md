# ros2-p5-dev
A lightweight collection of Ubuntu-based Docker images featuring ROS2 and the Processing IDE,
designed for personal development and prototyping, and quick experimentation.

All images in this repository are distributed under the [Apache License 2.0](./LICENSE).

## Features
- Preconfigured environments with ROS2 and Processing
- Accessible through a browser-based VNC interface
- Multiple image variants for different development needs
- Quick and portable -- no local installation required

## Available Images
Image Name         | Description
-------------------|-------------
ros2-p5-dev:latest | Base image with ROS2 and Processing IDE
ros2-p5-dev:hunmble| ROS2 Humble-based environment
ros2-p5-dev:jazzy  | ROS2 Jazzy-based environment
ros2-p5-dev:kilted | ROS2 Kilted-based environment

## Quick Start
1. Run the container. Replace `<tag>` with your desired image tag (e.g. `latest`).
```
$ docker run -d -p 6080:6080 --name ros2-p5-dev ghcr.io/sayakaakioka/ros2-p5-dev:<tag>
```

2. Open your browser and navigate to: http://localhost:6080/vnc.html?autoconnect=1
3. You will be automatically logged in as user `ubuntu`,
and an xterm window will open on startup.

## Launch Processing
The Processing IDE can be launched with
```
$ processing
```
The Processing IDE command at:
```
/usr/local/bin/processing
```
is a wrapper script that calls the actual Processing binary installed in the container.

## Tips
- Stop the container:
```
$ docker stop ros2-p5-dev
```
- Remove the container
```
$ docker rm ros2-p5-dev
```
- List all running containers:
```
$ docker ps
```


## License
This repository is licensed under the [Apache License 2.0](./LICENSE).

### Included Components
This Docker image includes third-party software distributed under their respective licenses.
Components        | License            | Website
------------------|--------------------|---------
ROS2              | Apache License 2.0 | https://www.ros.org/
Processing        | GPL v2 / LGPL v2.1 | https://processing.org/
Ubuntu Base Image | Ubuntu License     | https://ubuntu.com/legal/ubuntu-advantage-service-description

Each component retains its original license. This repository provides integration and environment setup for convenience.
