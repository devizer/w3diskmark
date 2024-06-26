set -eu
function My-Eval() {
    Say "[🠊] $*"
    time eval "$@"
}
chmod +x snap/hooks/configure
chmod +x w3diskmark
ver=$(cat bin-x64/VERSION); 
bash -e patch-snapcraft.sh "snap/snapcraft.yaml" "version" "$ver"

majorUbuntuVersion="$(source /etc/os-release; echo $VERSION_ID | awk -F'.' '{print $1}')"
bash -e patch-snapcraft.sh "snap/snapcraft.yaml" "base" "core${majorUbuntuVersion}"

# for arch in x64 arm64 arm; do cp -v w3diskmark bin-$arch/; done
pkill w3diskmark || true
My-Eval sudo snap remove --purge w3diskmark || true
rm -f w3diskmark*.snap || true

# My-Eval sudo snap install lxd || true
# My-Eval lxd init --auto || true
# My-Eval sudo lxd init --auto || true
# My-Eval sudo snap install strace-static
# My-Eval sudo lxc launch ubuntu:22.04

My-Eval snapcraft clean --destructive-mode || true
My-Eval sudo apt-get install liblttng-ust0 fio -y -q | grep "Unpack\|Setting" || true # missing in 22.04

if [[ "${AGENT_NAME:-}" == "Hosted Agent" ]] || [[ "${AGENT_NAME:-}" == "Azure Pipelines"* ]]; then mode="--destructive-mode"; else mode=""; fi
My-Eval sudo snapcraft $mode --debug
sudo ls -lah *.snap
Say "Success"
exit 0

# time sudo snapcraft clean 
# time sudo snapcraft clean --use-lxd --debug
# time sudo snapcraft --use-lxd --debug
