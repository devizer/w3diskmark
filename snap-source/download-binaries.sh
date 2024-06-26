work="$(pwd)"
pushd .
for arch in x64; do # SKIP: arm64 arm
  mkdir -p $work/bin-$arch
  Say "$arch --> $work/bin-$arch"
  cd $work/bin-$arch && rm -rf *
  url=https://github.com/devizer/w3top-bin/releases/latest/download/w3top-linux-$arch.tar.gz
  try-and-retry curl -ksfSL -o /tmp/w3diskmark-$arch.tar.xz "$url"
  tar xzf /tmp/w3diskmark-$arch.tar.xz
done
popd
