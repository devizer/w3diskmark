ARG RISK=edge
ARG UBUNTU=xenial

FROM ubuntu:$UBUNTU
ARG RISK
ARG UBUNTU
RUN echo "Building snapcraft:$RISK in ubuntu:$UBUNTU"

RUN set -eu; \
  EchoColored() { ANSI_NC='\033[0m'; ANSI_Color_Green='\033[1;32m'; ANSI_Color_Red='\033[1;31m'; ANSI_Color_Yellow='\033[1;33m'; color="$(eval "echo \$ANSI_Color_${1}")"; shift; if [ -z "${BASH_VERSION:-}" ]; then echo "${color}$*${ANSI_NC}"; else echo -e "${color}$*${ANSI_NC}"; fi; }; \
  EchoRedError() { EchoColored Red "\n$*\n"; }; \
  RetryOnFail() { "$@" && return; EchoRedError "Retrying 2 of 3 for '$*'"; sleep 1; "$@" && return; EchoRedError "Retrying 3 of 3 for '$*'"; sleep 1; "$@"; }; \
  EchoColored Green "[Provisioning Image $UBUNTU, snapcraft ver $RISK] apt update"; \
  RetryOnFail apt-get update -qq; \
  EchoColored Green "[Provisioning Image $UBUNTU, snapcraft ver $RISK] apt install curl"; \
  RetryOnFail sh -e -c "apt-get install -y -q curl | grep 'Unpack\|Setting'"; \
  script=https://raw.githubusercontent.com/devizer/test-and-build/master/install-build-tools-bundle.sh; (wget -q -nv --no-check-certificate -O - $script 2>/dev/null || curl -ksSL $script) | bash >/dev/null; \
  Say --Reset-Stopwatch; \
  Say "apt-get install jq squashfs-tools snapd locales ..."; \
  try-and-retry sh -e -c "apt-get install -y -q sudo jq squashfs-tools snapd locales | grep 'Unpack\|Setting'"; \
  locale-gen en_US.UTF-8; \
  arch="$(dpkg --print-architecture)"; \
  for snap in core core18 core20 core22 snapcraft; do \
    Say "DOWNLOADING SNAP=[$snap] for arch=[$arch]"; \
    urlQuery="https://api.snapcraft.io/api/v1/snaps/details/$snap"; \
    test "$snap" = "snapcraft" && urlQuery="${urlQuery}?channel=$RISK"; \
    echo "QUERY DOWNLOAD: [$urlQuery]"; \
    url="$(curl -ksSL -H 'X-Ubuntu-Series: 16' -H "X-Ubuntu-Architecture: $arch" "$urlQuery" | jq '.download_url' -r)"; \
    echo "URL: [$url]"; \
    curl -kSL "$url" --output $snap.snap; \
    mkdir -p /snap/$snap; \
    unsquashfs -d /snap/$snap/current $snap.snap; \
    rm -rf $snap.snap; \
  done; \
  Say "FINISH DOWNLOAD. Last, link snapcraft to proper python"; \
  apt-get clean; rm -rf /var/cache/apt/* /tmp/* /var/tmp/*


# Fix Python3 installation: Make sure we use the interpreter from
# the snapcraft snap:
RUN unlink /snap/snapcraft/current/usr/bin/python3
RUN ln -s /snap/snapcraft/current/usr/bin/python3.* /snap/snapcraft/current/usr/bin/python3
RUN echo /snap/snapcraft/current/lib/python3.*/site-packages >> /snap/snapcraft/current/usr/lib/python3/dist-packages/site-packages.pth

# Create a snapcraft runner (TODO: move version detection to the core of
# snapcraft).
RUN mkdir -p /snap/bin
RUN echo "#!/bin/sh" > /snap/bin/snapcraft
RUN snap_version="$(awk '/^version:/{print $2}' /snap/snapcraft/current/meta/snap.yaml | tr -d \')" && echo "export SNAP_VERSION=\"$snap_version\"" >> /snap/bin/snapcraft
RUN echo 'exec "$SNAP/usr/bin/python3" "$SNAP/bin/snapcraft" "$@"' >> /snap/bin/snapcraft
RUN chmod +x /snap/bin/snapcraft

# Set the proper environment.
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
ENV PATH="/snap/bin:/snap/snapcraft/current/usr/bin:$PATH"
ENV SNAP="/snap/snapcraft/current"
ENV SNAP_NAME="snapcraft"
# ENV SNAP_ARCH="amd64"

SHELL /bin/bash
ENTRYPOINT [ "/bin/bash", "-c", 'export SNAP_ARCH="$(dpkg --print-architecture)"; echo "Force SNAP_ARCH=$SNAP_ARCH"; bash -c' ]
