FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

# Install ruby-build dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    bison \
    build-essential \
    curl \
    git \
    libdb-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    libncurses5-dev \
    libreadline-dev \
    libssl-dev \
    libyaml-dev \
    patch \
    rustc \
    uuid-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ruby-build
RUN git clone https://github.com/rbenv/ruby-build.git /opt/ruby-build \
    && /opt/ruby-build/install.sh

# Copy build definitions (all version files from repo root) and the patches they apply,
# which they find beside themselves
WORKDIR /definitions
COPY [0-9]* ./
COPY patches/ ./patches/

ENV RUBY_BUILD_DEFINITIONS=/definitions

# Default to bash for interactive use
CMD ["/bin/bash"]
