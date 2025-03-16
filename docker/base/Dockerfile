FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y sudo

COPY sudoers /etc/sudoers.d/default

RUN useradd -ms /bin/bash ubuntu
RUN usermod -aG sudo ubuntu

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y bzip2 curl cpio wget xz-utils

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=toolchains,target=/tmp/toolchains \
    bash /tmp/toolchains/setup.sh

ENV AARCH64_TOOLCHAIN="/opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
ENV MIPS_TOOLCHAIN="/opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu"
ENV MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"

ENV PATH="${PATH}:${AARCH64_TOOLCHAIN}/bin:${MIPS_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y make

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y gcc gcc-multilib

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y musl musl-dev musl-tools

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=dietlibc,target=/tmp/dietlibc \
    bash /tmp/dietlibc/setup.sh

ENV DIETLIBC="/opt/diet"
ENV PATH="${PATH}:${DIETLIBC}/bin"

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y liblz4-dev liblzma-dev liblzo2-dev libzstd-dev zlib1g-dev

RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y upx

RUN echo '\n\
# SHELL EXTENSIONS IN /etc/bashrc.d\n\
for file in /etc/bashrc.d/*.sh; do\n\
    . "$file"\n\
done\n\
' >> /etc/bash.bashrc

COPY bashrc.d /etc/bashrc.d

WORKDIR /build

USER ubuntu

CMD [ "/build/scripts/from_docker.sh" ]
