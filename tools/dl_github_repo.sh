set -x
basedir=$(realpath "${0%/*}")

git clone https://github.com/Mimickal/wormhole-cli.git
cd wormhole-cli
npm ci
npm install -g

cd "$basedir"
command -v wormhole-cli >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
. ./downGithubRep.sh
downGithubRep https://github.com/UIZorrot/Quenching-Assets.git
