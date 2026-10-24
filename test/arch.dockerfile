FROM archlinux:latest

# Install ruby-build dependencies
RUN pacman -Syu --noconfirm \
    autoconf \
    base-devel \
    bison \
    git \
    gmp \
    libffi \
    libyaml \
    openssl \
    patch \
    readline \
    rust \
    zlib \
    && pacman -Scc --noconfirm

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
