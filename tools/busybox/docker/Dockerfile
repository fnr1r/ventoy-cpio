FROM ventoy2-base

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y \
        gcc make

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y \
        perl

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y \
        bzip2 xz-utils

WORKDIR /build

USER ubuntu

#COPY scripts /home/ubuntu/scripts

#COPY toolchains /home/ubuntu/.cache/ventoy_builder
#RUN sudo chown -R ubuntu: /home/ubuntu/.cache

#RUN bash /home/ubuntu/scripts/download_toolchains.sh

CMD [ "make", "-C", "tools/busybox" ]
