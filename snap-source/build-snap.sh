set -eu
function My-Eval() {
    Say "[Invoking] $*"
    time eval "$@"
}
chmod +x snap/hooks/configure
chmod +x w3diskmark
ver=$(cat bin-x64/VERSION); sed -i "/^version\:/d" snap/snapcraft.yaml; printf "\n\nversion: $ver\n" >> snap/snapcraft.yaml; echo "SNAP VERSION: $ver"
for arch in x64 arm64 arm; do cp -v w3diskmark bin-$arch/; done
pkill w3diskmark || true
My-Eval sudo snap remove --purge w3diskmark || true
rm -f w3diskmark*.snap || true

My-Eval lxd init --auto || true
My-Eval sudo lxd init --auto || true
My-Eval time sudo lxc launch ubuntu:22.04


My-Eval sudo snap install strace-static
My-Eval snapcraft clean  || true
My-Eval sudo apt-get install liblttng-ust0 fio -y -q || true # missing in 22.04
My-Eval sudo snapcraft --strace --destructive-mode --debug
Say "Success"
exit 0

# time sudo snapcraft clean 
# time sudo snapcraft clean --use-lxd --debug
# time sudo snapcraft --use-lxd --debug
