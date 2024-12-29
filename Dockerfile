FROM ubuntu:16.04 
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    vim \
    gcc-4.9 \
    git \
    zlib1g-dev \
    && apt-get clean

# Set working directory
WORKDIR /workspace

# Install squashfs-tools 3.2
RUN cd /opt/  \
        && git clone https://github.com/plougher/squashfs-tools.git \
        && cd squashfs-tools/ \
        && git checkout 8d0943c51b1c0eb7513763440f32711069dba8ed \
        && cd squashfs-tools/ \
        && CC=gcc-4.9 CFLAGS="-fpermisive" make all
ENV PATH="/opt/squashfs-tools/squashfs-tools/:${PATH}"
CMD ["bash"]
