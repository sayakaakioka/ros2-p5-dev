# ros2-p5-dev
A lightweight Ubuntu-based Docker image featuring ROS2 and the Processing IDE,
designed for personal development and prototyping.

All images in this repository are distributed under the [Apache License 2.0](./LICENSE).

## Features
- Preconfigured environment with ROS2 and Processing
- Accessible via a browser-based VNC interface
- Suitable for quick experimentation, testing, and education

## Usage
1. Run the container.
2. Open your browser and navigate to: http://localhost:6080/vnc.html?autoconnect=1
3. You will be automatically logged in as user `ubuntu`,
and an xterm window will open.
4. The Processing executable can be launched via the wrapper script located at `/usr/local/bin/processing`. The path points to a wrapper script that invokes the actual Processing binary.

## License
This repository is licensed under the [Apache License 2.0](./LICENSE).

### Included Components
This Docker image includes third-party software distributed under their respective licenses:

- ROS2: Apache License 2.0 (https://www.ros.org/)
- Processing: GPL v2 / LGPL v2.1 (https://processing.org/)
- Ubuntu Base Image: Ubuntu License (https://ubuntu.com/legal/ubuntu-advantage-service-description)

Each component retains its original license. This repository provides integration and environment setup for convenience.
