FROM alpine:latest
RUN --mount=type=cache,target=/var/cache/apk \
    apk add bash curl wget xz

RUN --mount=type=bind,source=toolchains,target=/tmp/toolchains \
    bash /tmp/toolchains/setup.sh



FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y curl wget xz-utils

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y make

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y gcc gcc-multilib

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    apt-get install -y patch

COPY --from=0 /opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu /opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu
COPY --from=0 /opt/aarch64--uclibc--stable-2020.08-1 /opt/aarch64--uclibc--stable-2020.08-1
COPY --from=0 /opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu /opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu
COPY --from=0 /opt/mips64el-linux-gnu-musl-gcc7.3.0 /opt/mips64el-linux-gnu-musl-gcc7.3.0

ENV AARCH64_GNU_TOOLCHAIN="/opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
ENV AARCH64_UCLIBC_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"
ENV MIPS_TOOLCHAIN="/opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu"
ENV MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"

ENV PATH="${PATH}:${AARCH64_GNU_TOOLCHAIN}/bin:${AARCH64_UCLIBC_TOOLCHAIN}/bin:${MIPS_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"

RUN --mount=type=cache,id=/var/cache/apt/archives-2,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-2,target=/var/lib/apt/lists \
    --mount=type=bind,source=dietlibc,target=/tmp/dietlibc \
    bash /tmp/dietlibc/setup.sh



FROM --platform=linux/386 ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=/var/lib/apt/lists-386,target=/var/lib/apt/lists \
    apt-get update

RUN --mount=type=cache,id=/var/cache/apt/archives-386,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-386,target=/var/lib/apt/lists \
    apt-get install -y gcc make xz-utils

RUN --mount=type=cache,id=/var/cache/apt/archives-386,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-386,target=/var/lib/apt/lists \
    apt-get install -y patch

RUN --mount=type=cache,id=/var/cache/apt/archives-386,target=/var/cache/apt/archives \
    --mount=type=cache,id=/var/lib/apt/lists-386,target=/var/lib/apt/lists \
    --mount=type=bind,source=dietlibc,target=/tmp/dietlibc \
    bash /tmp/dietlibc/setup.sh 386



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
    apt-get install -y bzip2 curl cpio wget xz-utils

RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y make

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
    apt-get install -y upx zstd

# this is required for some programs to compile with musl-gcc
RUN for i in asm-generic asm linux mtd; do \
        ln -s ../$i /usr/include/x86_64-linux-musl/$i; \
    done

# conveniences
RUN --mount=type=cache,target=/var/cache/apt/archives \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install -y file fish

COPY --from=0 /opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu /opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu
COPY --from=0 /opt/aarch64--uclibc--stable-2020.08-1 /opt/aarch64--uclibc--stable-2020.08-1
COPY --from=0 /opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu /opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu
COPY --from=0 /opt/mips64el-linux-gnu-musl-gcc7.3.0 /opt/mips64el-linux-gnu-musl-gcc7.3.0

ENV AARCH64_GNU_TOOLCHAIN="/opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
ENV AARCH64_UCLIBC_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"
ENV MIPS_TOOLCHAIN="/opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu"
ENV MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"

ENV PATH="${PATH}:${AARCH64_GNU_TOOLCHAIN}/bin:${AARCH64_UCLIBC_TOOLCHAIN}/bin:${MIPS_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"

COPY --from=1 /opt/diet /opt/diet

ENV DIETLIBC="/opt/diet"
ENV PATH="${PATH}:${DIETLIBC}/bin"

COPY --from=2 /opt/diet32 /opt/diet32

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
