# ros2-p5-dev
A lightweight collection of Ubuntu-based Docker images featuring ROS2 and the Processing IDE,
designed for personal development and prototyping, and quick experimentation.

All images in this repository are distributed under the [Apache License 2.0](./LICENSE).

## Features
- Preconfigured environments with ROS2 and Processing
- Accessible through a browser-based VNC (`noVNC` at port 6080)
- Multiple image variants corresponding to different ROS2 distros
- Multi-architecture support (amd64/arm64)
- Quick, portable, and requires no local installation

## Available Image Tags
Image Tag         | Description
-------------------|-------------
ghcr.io/sayakaakioka/ros2-p5-dev:latest` | Latest stable build (points to the newest ROS2 distro, currently **Kilted**)
ghcr.io/sayakaakioka/ros2-p5-dev:ros2-kilted | ROS2 Kilted-based environment
ghcr.io/sayakaakioka/ros2-p5-dev:ros2-jazzy | ROS2 Jazzy-based environment
ghcr.io/sayakaakioka/ros2-p5-dev:ros2-humble | ROS2 Humble-based environment
ghcr.io/sayakaakioka/ros2-p5-dev:vX.Y-ros2-`<distro>` | Version-locked tag (e.g. `v2.7-ros2-humble`)

The `latest` tag is updated automatically on each GitHub Release.

## Releases
See all published versions and changelogs at [GitHub Releases](https://github.com/sayakaakioka/ros2-p5-dev/releases)

The release notes are automatically generated when new tags (e.g., `v2.7`) are pushed.
Each release provides prebuilt multi-arch images for all supported ROS2 distros.

## Quick Start
1. Run the container. Replace `<tag>` with your desired image tag (e.g. `ros2-kilted` or `latest`):
```
$ docker run -d -p 6080:6080 --name ros2-p5-dev ghcr.io/sayakaakioka/ros2-p5-dev:<tag>
```

2. Open your browser at http://localhost:6080/vnc.html?autoconnect=1
3. You will be logged in as user `ubuntu`,
and an xterm window will start automatically.

## Launch Processing
Inside the container:
```
$ processing
```
The command `/usr/local/bin/processing` is a wrapper that configures environment variables and launches the actual Processing binary installed in `/opt/processing`.

## Common Commands
- Stop the container:
```
$ docker stop ros2-p5-dev
```
- Remove the container
```
$ docker rm ros2-p5-dev
```
- List running containers:
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
