  for snap in core core18 core20 core22 snapcraft; do \
    Say "DOWNLOADING SNAP $snap"; \
    urlQuery="https://api.snapcraft.io/api/v1/snaps/details/$snap"; \
    test "$snap" = "snapcraft" && urlQuery="${urlQuery}?channel=$RISK"; \
    echo "QUERY DOWNLOAD: [$urlQuery]"; \
    url="$(curl -ksSL -H 'X-Ubuntu-Series: 16' "$urlQuery" | jq '.download_url' -r)"; \
    echo "URL: [$url]"; \
    curl -kSL "$url" --output $snap.snap; \
    mkdir -p /snap-temp/$snap; \
    unsquashfs -d /snap-temp/$snap/current $snap.snap; \
    rm -rf $snap.snap; \
  done; \
  Say "FINISH"; \
