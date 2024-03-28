set -eu; set -o pipefail
work=$HOME/build/w3diskmark-local
if [[ ! -d $work ]]; then git clone https://github.com/devizer/w3diskmark $work; fi
# Alter upgrade: rm -rf $work/*
cd $work
git reset --hard; git pull; 
cd snap-source; 
if [[ ! -d bin-x64 ]]; then bash -e download-binaries.sh || rm -rf bin-a*; fi
bash -e patch-snapcraft.sh "snap/snapcraft.yaml" "confinement" "classic"
time bash -e build-snap.sh;
sudo snap install w3diskmark_*.snap --dangerous --classic
sudo snap set w3diskmark http.port=5555
sudo snap restart w3diskmark
sleep 9
sudo snap logs -n=1000 w3diskmark.service

