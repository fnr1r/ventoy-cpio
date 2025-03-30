FROM alpine:latest AS toolchains
RUN --mount=type=cache,target=/var/cache/apk \
    apk add bash curl wget xz

RUN --mount=type=bind,source=toolchains,target=/tmp/toolchains \
    bash /tmp/toolchains/setup.sh



FROM ubuntu:20.04 AS diet64
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y curl wget xz-utils

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y make patch

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y gcc gcc-multilib

COPY --from=toolchains /opt/aarch64--uclibc--stable-2020.08-1 /opt/aarch64--uclibc--stable-2020.08-1

ENV AARCH64_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"

ENV PATH="${PATH}:${AARCH64_TOOLCHAIN}/bin"

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    --mount=type=bind,source=dietlibc,target=/tmp/dietlibc \
    bash /tmp/dietlibc/setup.sh



FROM --platform=linux/386 debian:12-slim AS diet32
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=/var/lib/apt/lists-diet32,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,id=/var/cache/apt/archives-diet32,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-diet32,target=/var/lib/apt/lists \
    apt-get install -y gcc make patch wget xz-utils

RUN --mount=type=bind,source=dietlibc,target=/tmp/dietlibc \
    bash /tmp/dietlibc/setup.sh i386



FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y sudo

COPY sudoers /etc/sudoers.d/default

RUN useradd -ms /bin/bash ubuntu
RUN usermod -aG sudo ubuntu

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y bzip2 curl cpio wget xz-utils zstd

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y make patch

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y gcc gcc-multilib

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y musl musl-dev musl-tools

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y liblz4-dev liblzma-dev liblzo2-dev libzstd-dev zlib1g-dev

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y upx

# this is required for some programs to compile with musl-gcc
RUN for i in asm-generic asm linux mtd; do \
        ln -s ../$i /usr/include/x86_64-linux-musl/$i; \
    done

# conveniences
RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y file fish

COPY --from=toolchains /opt/aarch64--uclibc--stable-2020.08-1 /opt/aarch64--uclibc--stable-2020.08-1
COPY --from=toolchains /opt/mips64el-linux-gnu-musl-gcc7.3.0 /opt/mips64el-linux-gnu-musl-gcc7.3.0

ENV AARCH64_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"
ENV MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"

ENV PATH="${PATH}:${AARCH64_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"

COPY --from=diet32 /opt/diet32 /opt/diet32
COPY --from=diet64 /opt/diet /opt/diet

ENV DIETLIBC="/opt/diet"

RUN ln -s /opt/diet/bin/diet /usr/local/bin/diet
RUN ln -s /opt/diet/bin/diet /usr/local/bin/diet64
RUN ln -s /opt/diet32/bin/diet /usr/local/bin/diet32

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
