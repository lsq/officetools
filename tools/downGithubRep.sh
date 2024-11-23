#/bin/env bash

downGithubRep() {
#gitUrl="${1/%.git/}"
gitUrl="${1/%.git/}"
githubRep="${gitUrl##*/}"
git clone "$gitUrl" "$githubRep"
7z a -mx=9 "${githubRep}.zip" "$githubRep"
wormhole-cli "${githubRep}.zip"
}
