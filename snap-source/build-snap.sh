set -eu
chmod +x snap/hooks/configure
chmod +x w3diskmark
ver=$(cat bin-x64/VERSION); sed -i "/^version\:/d" snap/snapcraft.yaml; printf "\n\nversion: $ver\n" >> snap/snapcraft.yaml; echo "SNAP VERSION: $ver"
for arch in x64 arm64 arm; do cp -v w3diskmark bin-$arch/; done
pkill w3diskmark || true
sudo snap remove --purge w3diskmark || true
rm -f w3diskmark*.snap || true
# snapcraft clean; 
# time sudo snapcraft --destructive-mode --debug
time sudo snapcraft clean 
time sudo snapcraft clean --use-lxd --debug
time sudo snapcraft --use-lxd --debug
