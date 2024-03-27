work="$(pwd)"
pushd .
for arch in x64 arm64 arm; do
  mkdir -p $work/bin-$arch
  Say "$arch --> $work/bin-$arch"
  cd $work/bin-$arch && rm -rf *
  url=https://github.com/devizer/w3top-bin/releases/latest/download/w3top-linux-$arch.tar.xz
  try-and-retry curl -kfSL -o /tmp/w3diskmark-$arch.tar.xz "$url"
  tar xJf /tmp/w3diskmark-$arch.tar.xz
done
popd
