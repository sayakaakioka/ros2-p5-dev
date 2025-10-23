ARG UBUNTU_TAG=24.04
FROM ubuntu:${UBUNTU_TAG}

ARG TARGETARCH
ARG PROCESSING_VERSION
ARG PROCESSING_BUILD
ARG ROS_DISTRO
SHELL ["/bin/bash", "-c"]

# Preparation
ENV TZ=Asia/Tokyo ROS_DISTRO=${ROS_DISTRO}
  RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN apt-get update && apt-get install --no-install-recommends -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y curl ca-certificates gnupg
RUN curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
      http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
      > /etc/apt/sources.list.d/ros2.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ros-${ROS_DISTRO}-desktop ros-dev-tools; \
    rm -rf /var/lib/apt/lists/*

# Processing + GUI tools installation
RUN apt-get update && apt-get install --no-install-recommends -y \
    unzip lsb-release \
    xvfb x11vnc fluxbox websockify novnc supervisor \
    mesa-utils libgl1 libglu1-mesa libxi6 libxrender1 libxtst6 \
    libxrandr2 libxinerama1 libxxf86vm1 libgtk-3-0 \
    xauth x11-apps xterm sudo x11-xserver-utils \
    dbus-x11 libgl1-mesa-dri

RUN set -eux; \
  : "${TARGETARCH:=amd64}"; \
  case "${TARGETARCH}" in \
    amd64)   PFILE="processing-${PROCESSING_VERSION}-linux-x64-portable.zip" ;; \
    arm64)   PFILE="processing-${PROCESSING_VERSION}-linux-aarch64-portable.zip" ;; \
    *) echo "unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
  esac; \
  TAG="processing-${PROCESSING_BUILD}-${PROCESSING_VERSION}"; \
  URL="https://github.com/processing/processing4/releases/download/${TAG}/${PFILE}"; \
  echo "Fetching Processing from: ${URL}"; \
  curl -fL --retry 5 --retry-delay 3 --retry-connrefused -o /tmp/processing.zip "${URL}"; \
  rm -rf /tmp/p5; mkdir -p /tmp/p5; \
  unzip -q /tmp/processing.zip -d /tmp/p5; \
  dir="$(find /tmp/p5 -maxdepth 1 -type d \( -iname 'processing*' -o -iname 'Processing*' \) | head -n1)"; \
  test -n "$dir"; \
  rm -rf /opt/processing; mv "$dir" /opt/processing; \
  exe="$(find /opt/processing -maxdepth 3 -type f \( -iname processing -o -iname Processing \) | head -n1)"; \
  test -x "$exe"; \
  printf '%s\n' '#!/usr/bin/env bash' \
    'export LIBGL_ALWAYS_SOFTWARE=${LIBGL_ALWAYS_SOFTWARE:-1}' \
    'export SKIKO_RENDER_API=${SKIKO_RENDER_API:-SOFTWARE}' \
    'export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}' \
    'export _JAVA_OPTIONS="${_JAVA_OPTIONS:-} --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/sun.awt=ALL-UNNAMED"' \
    'export NO_AT_BRIDGE=${NO_AT_BRIDGE:-1}' \
    'command -v dbus-launch >/dev/null 2>&1 && [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && eval $(dbus-launch --sh-syntax) || true' \
    "exec \"$exe\" \"\$@\"" > /usr/local/bin/processing && chmod +x /usr/local/bin/processing; \
  rm -rf /tmp/processing.zip /tmp/p5

# user ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir -p /home/ubuntu/.config /home/ubuntu/.cache /home/ubuntu/.local/share \
  && chown -R ubuntu:ubuntu /home/ubuntu/.config /home/ubuntu/.cache /home/ubuntu/.local
WORKDIR /home/ubuntu

# supervisor settings
RUN printf '%s\n' \
  '[program:xvfb]' \
  'command=/usr/bin/Xvfb :0 -screen 0 1280x800x24 -nolisten tcp -ac' \
  'priority=10' 'autorestart=true' 'startsecs=1' \
  '' \
  '[program:fluxbox]' \
  'user=ubuntu' \
  'environment=DISPLAY=":0",HOME="/home/ubuntu",USER="ubuntu",LOGNAME="ubuntu",SHELL="/bin/bash",XDG_CONFIG_HOME="/home/ubuntu/.config"' \
  'command=/usr/bin/fluxbox' \
  'priority=20' 'autorestart=true' 'startsecs=1' \
  '' \
  '[program:bg]' \
  'user=ubuntu' \
  'environment=DISPLAY=":0",HOME="/home/ubuntu",XDG_CONFIG_HOME="/home/ubuntu/.config"' \
  'command=/bin/sh -lc "xsetroot -solid #3c4259"' \
  'priority=25' 'autorestart=false' 'startsecs=1' \
  '' \
  '[program:xterm]' \
  'user=ubuntu' \
  'environment=DISPLAY=":0",HOME="/home/ubuntu",USER="ubuntu",LOGNAME="ubuntu",SHELL="/bin/bash",XDG_CONFIG_HOME="/home/ubuntu/.config"' \
  'command=/bin/sh -lc "sleep 2; /usr/bin/xterm -fa Monospace -fs 11 -geometry 100x30+40+40"' \
  'priority=30' 'autorestart=true' 'startsecs=1' 'startretries=999' \
  '' \
  '[program:x11vnc]' \
  'command=/usr/bin/x11vnc -display :0 -forever -nopw -rfbport 5900 -shared' \
  'priority=40' 'autorestart=true' 'startsecs=1' \
  '' \
  '[program:novnc]' \
  'command=/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 0.0.0.0:6080' \
  'priority=50' 'autorestart=true' 'startsecs=1'\
  > /etc/supervisor/conf.d/gui.conf

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
