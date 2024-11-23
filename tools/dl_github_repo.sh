set -x
basedir=$(realpath "${0%/*}")

git clone https://github.com/Mimickal/wormhole-cli.git
cd wormhole-cli
cat > .puppeteerrc.cjs << 'EOF'
const {join} = require('path');

/**
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  //cacheDirectory: join(__dirname, '.cache', 'puppeteer'),
  executablePath: '',
};
EOF
sed -i '/"puppeteer": /s/21/23/' package.json
npm ci
npm install -g

cd "$basedir"
command -v wormhole-cli >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
. ./downGithubRep.sh
downGithubRep https://github.com/UIZorrot/Quenching-Assets.git
