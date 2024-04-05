ARG RISK=edge
ARG UBUNTU=xenial

FROM ubuntu:$UBUNTU
ARG RISK
ARG UBUNTU
RUN echo "Building snapcraft:$RISK in ubuntu:$UBUNTU"

RUN set -eu; \
  apt-get update -q || apt-get update -q || apt-get update -q; \
  apt-get install -y -q curl sudo jq squashfs-tools snapd locales; \
  locale-gen en_US.UTF-8; \
  script=https://raw.githubusercontent.com/devizer/test-and-build/master/install-build-tools-bundle.sh; (wget -q -nv --no-check-certificate -O - $script 2>/dev/null || curl -ksSL $script) | bash; \
  Say --Reset-Stopwatch; \
  for snap in core core18 core20 core22 snapcraft; do \
    Say "DOWNLOADING SNAP $snap"; \
    urlQuery="https://api.snapcraft.io/api/v1/snaps/details/$snap"; \
    test "$snap" = "snapcraft" && urlQuery="${urlQuery}?channel=$RISK"; \
    echo "QUERY DOWNLOAD: [$urlQuery]"; \
    url="$(curl -ksSL -H 'X-Ubuntu-Series: 16' "$urlQuery" | jq '.download_url' -r)"; \
    echo "URL: [$url]"; \
    curl -kSL "$url" --output $snap.snap; \
    mkdir -p /snap/$snap; \
    unsquashfs -d /snap/$snap/current $snap.snap; \
    rm -rf $snap.snap; \
  done; \
  Say "FINISH"; \
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
ENV SNAP_ARCH="amd64"
