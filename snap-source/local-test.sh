set -eu; set -o pipefail
work=$HOME/build/w3diskmark-local
if [[ ! -d $work ]]; then git clone https://github.com/devizer/w3diskmark $work; fi
# Alter upgrade: rm -rf $work/*
cd $work
cd snap-source; 
if [[ ! -d bin-x64 ]]; then bash -e download-binaries.sh || rm -rf bin-a*; fi
git reset --hard; git pull; time bash -e build-snap.sh;
sudo snap install w3diskmark_*.snap --dangerous --classic
sudo snap set w3diskmark http.port=5555
sudo snap restart w3diskmark
sleep 5
sudo snap logs -n=1000 w3diskmark.service

