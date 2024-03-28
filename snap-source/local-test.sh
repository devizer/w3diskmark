set -eu; set -o pipefail
work=$HOME/build/w3diskmark-local
if [[ ! -d $work ]]; then git clone https://github.com/devizer/w3diskmark $work; fi
cd $work
cd snap-source; 
if [[ ! -d bin-x64 ]]; then bash -e download-binaries.sh || rm -rf bin-a*; fi
git pull; time bash -e build-snap.sh;

