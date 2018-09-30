FROM contribu/buildenv_docker

RUN \
  wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
  && apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
  && wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list \
  && apt-get update \
  && apt-get install -y \
    intel-ipp-64bit-2019.0-045 \
    libboost-all-dev \
    libc6-dbg \
    libgtest-dev \
  && ( \
    cd $(mktemp -d) \
    && echo 'install latest valgrind to support instructions used in ipp' \
    && echo 'libc6-dbg is required' \
    && wget ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2 \
    && tar xf valgrind-3.13.0.tar.bz2 \
    && cd valgrind-3.13.0 \
    && ./configure \
    && make -j `nproc` \
    && make install \
  ) \
  && ( \
    cd $(mktemp -d) \
    && git clone https://github.com/google/benchmark.git \
    && cd benchmark \
    && mkdir build \
    && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
    && make -j 1 \
    && make install \
  ) \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*
