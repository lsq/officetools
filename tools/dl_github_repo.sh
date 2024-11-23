set -x

git clone https://github.com/Mimickal/wormhole-cli.git
cd wormhole-cli
npm ci
npm install -g

[ command -v wormhole-cli ] || exit 1
. ./downGithubRep.sh
downGithubRep https://github.com/UIZorrot/Quenching-Assets.git
