FROM ffhef/debian-batman:8.3-2017.0

ENV PACKAGES="libcap2 libcap-dev bison pkg-config libsodium13 libsodium-dev cmake libssl1.0.0 libssl-dev git build-essential libjson-c2 libjson-c-dev bridge-utils"
ENV REMOVE_PACKAGES="libcap-dev bison pkg-config libsodium-dev cmake libssl-dev git build-essential libjson-c-dev"

RUN apt-get update && \
    apt-get install -y $PACKAGES && \
    cd /usr/src && \
    git clone --branch v7 git://git.universe-factory.net/libuecc && \
    mkdir libuecc-build && \
    cd libuecc-build && \
    cmake ../libuecc -DCMAKE_BUILD_TYPE=RELEASE && \
    make && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    rm -r /usr/src/libuecc && \
    rm -r /usr/src/libuecc-build && \
    cd /usr/src && \
    git clone --branch v18 git://git.universe-factory.net/fastd && \
    mkdir fastd-build && \
    cd fastd-build && \
    cmake ../fastd -DCMAKE_BUILD_TYPE=RELEASE && \
    make && \
    make install && \
    rm -r /usr/src/fastd && \
    rm -r /usr/src/fastd-build && \
    apt-get remove -y $REMOVE_PACKAGES && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/*
    
EXPOSE 10000/udp

ADD /entrypoint.sh /
ADD /fastd.conf.in /etc/fastd/fastd.conf.in

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--config", "/etc/fastd/fastd.conf" ]