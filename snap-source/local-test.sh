set -eu; set -o pipefail
work=$HOME/build/w3diskmark
if [[ ! -d $work ]]; then git clone https://github.com/devizer/w3diskmark $work; fi
cd $work
git pull
cd snap-source; 
if [[ ! -d bin-amd64 ]]; then bash -e download-binaries.sh || rm -rf bin-a*; fi
bash -e build-snap.sh;
