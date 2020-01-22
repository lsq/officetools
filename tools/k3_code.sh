#!/usr/bin/env bash

# more curl info https://msd.misuland.com/pd/3113337336633494028

function gentimestamp() { 
	date +%s%3N
}

function uploadimg() {
	local url="$2"
	local filepath="$1"

	curl -F 'file=@'${filepath} "$url" #'https://ocr.wdku.net/Upload'
}

function postinfo(){
	local url="$3"
	local ids="$1"
	local tmst="$2"

	curl -d "obj_type=txt3&ids=${ids}&ts=${tmst}&pass=&lang=2&autorotation=true&combine=true&a4=false&color=false" $url
}

function checkorcresponse(){
	local url="$2"
	local id="$1"
	#local ts=gentimestamp

	curl -d "check=yes" "$url?id=${id}&_t=$(gentimestamp)" | sed -n 's/.*"status":\([0-9]\+\).*/\1/p'
}

function getresult(){
	local url="$3"
	local id="$1"
	local ts="$2"
	curl "$url?id=${id}&t=${ts}&type=other"
}

function analysisid(){
	local json="$1"

	sed -n 's/.*"id":"\(.*\)",.*/\1/p' <<<"$json"
}

function analysistimestamp(){
	#local timestamp
	local json="$1"

	sed -n 's/.*"time":\([0-9]\+\).*/\1/p' <<<"$json"
}

function analysisresult(){
	local contents="$1"

	#while read -ra line
	sed -n '1{s/ //gp}' <<<"$contents"
}

uploadinfo=$(uploadimg ./d.jpg https://ocr.wdku.net/Upload)
imgid=$(analysisid "$uploadinfo")
echo $imgid
imgts=$(analysistimestamp "$uploadinfo")
echo $imgts

pstinfo=$(postinfo "$imgid" "$imgts" https://ocr.wdku.net/submitOcr?type=1)
grep '"errno":10106' <<<"$pstinfo" && exit
pstid=$(analysisid $pstinfo)

ocrcode=$(checkorcresponse "$pstid" https://ocr.wdku.net/waitResult2)
while [[ $ocrcode -ne 1 ]]; do
	sleep 2s
	ocrcode=$(checkorcresponse "$pstid" https://ocr.wdku.net/waitResult2)
done

printf "$(analysisresult `getresult "$imgid" $imgts https://ocr.wdku.net/downResult`)"



