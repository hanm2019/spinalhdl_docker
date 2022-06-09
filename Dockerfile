FROM ubuntu:18.04

RUN apt update -qq && \
    apt upgrade -y && \
    apt install -y --no-install-recommends apt-utils apt-transport-https ca-certificates git make && \
    apt install -y --no-install-recommends openjdk-11-jdk && \
    apt install -y --no-install-recommends libgnat-8  python3 python3-pip python3-dev swig zlib1g-dev libboost-dev && \
    apt install -y --no-install-recommends g++ curl scala gnupg2 && \
    apt install -y --no-install-recommends git make autoconf g++ flex bison libfl2 libfl-dev && \
    apt autoclean && \
    apt clean && \
    apt -y autoremove  && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

RUN python3 -m pip install --upgrade pip setuptools
RUN pip3 install cocotb

RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" |  tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" |  tee /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" |  apt-key add && \
    apt update -qq && \
    apt install -y --no-install-recommends sbt  && \
    apt autoclean && apt clean && apt -y autoremove && \
     rm -rf /var/lib/apt/lists/* 
     
RUN  curl -L https://github.com/lihaoyi/mill/releases/download/0.7.3/0.7.3 > /usr/local/bin/mill && \
    chmod +x /usr/local/bin/mill && \
    mkdir -p /root/.cache/mill/download && \
    curl --fail -L -o /root/.cache/mill/download/0.7.3-tmp-download https://github.com/com-lihaoyi/mill/releases/download/0.7.3/0.7.3-assembly && \
    chmod +x /root/.cache/mill/download/0.7.3-tmp-download && \
    mv /root/.cache/mill/download/0.7.3-tmp-download /root/.cache/mill/download/0.7.3



# RUN git clone -b v1.7.0 --depth=1 --recurse-submodule https://github.com/SpinalHDL/SpinalHDL.git /opt/SpinalHDL && cd /opt/SpinalHDL \
#  && sbt clean compile publishLocal


RUN git clone -b v4.040 --depth=1 http://git.veripool.org/git/verilator  /opt/verilator && cd /opt/verilator && \
    unset VERILATOR_ROOT && \
    autoconf && \
     ./configure && \
    make -j4 && \
    make install && \
    rm -rf /opt/verilator

RUN curl  -O https://cmake.org/files/v3.20/cmake-3.20.0-linux-x86_64.tar.gz  \
    && tar -zxvf cmake-3.20.0-linux-x86_64.tar.gz \
    && mv cmake-3.20.0-linux-x86_64 /opt/cmake \
    && ln -sf /opt/cmake/bin/* /usr/bin \
    && rm cmake-3.20.0-linux-x86_64.tar.gz