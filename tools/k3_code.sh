#!/usr/bin/env bash

# more curl info https://msd.misuland.com/pd/3113337336633494028
# curl 'https://usky.ml/tool/api/free_ssr?page=1&limit=10' -H 'authority: usky.ml' -H 'accept: application/json, text/javascript, */*; q=0.01' -H 'x-requested-with: XMLHttpRequest' -H 'user-agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'sec-fetch-site: same-origin' -H 'sec-fetch-mode: cors' -H 'referer: https://usky.ml/tool/free_ssr' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: zh-CN,zh;q=0.9' -H 'cookie: __cfduid=d15e1c299de788bdf1c22d05d9a00e4d01579690903; xf_session=5a20e5238ccdf355f8123ebdd2cf597d; _ga=GA1.2.1162918659.1579690908; _gid=GA1.2.595927745.1579690908; _gat_gtag_UA_114232786_1=1; JSESSIONID=AF6CF344C8A7E0D4092658B331683B7B; _gat_gtag_UA_114706424_1=1' --compressed
# https://github.com/jhao104/proxy_pool
# http://www.xiladaili.com/
# https://www.freeip.top/?page=1&protocol=https
#  http://118.24.52.95/get

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

#	curl -d "obj_type=txt3&ids=${ids}&ts=${tmst}&pass=&lang=2&autorotation=true&combine=true&a4=false&color=false" $url
	curl -d "obj_type=txt3&ids=${ids}&ts=${tmst}&pass=&lang=2&autorotation=true&combine=true&a4=false&color=true" $url
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
	sed -n '1{s/[^0-9A-Za-z]//g;p;q}' <<<"$contents"
}

function changeproxy() {
	[ -s ~/.curlrc ] ||  echo '# proxy setting' >> ~/.curlrc

	local freeip
	local count=1
	local ip

	freeip="$(curl https://www.freeip.top/api/proxy_ip)"
	until grep '"protocol":"https"' <<<"$freeip";do
		freeip="$(curl https://www.freeip.top/api/proxy_ip)"
		sleep 2s
		if [[ $count -gt 10 ]];then
			break
		fi
		$((count++))
		continue
	done

	ip=`sed 's/.*"ip":"\(.*\)","port":"\([0-9]\+\)".*/\1:\2/' <<<"$freeip"`

	sed -i '/^proxy/{s/^\(proxy=\)\(.*\)$/\1'$ip'/;q};$a\proxy='$ip'' ~/.curlrc
}

uploadinfo=$(uploadimg ./d.jpg https://ocr.wdku.net/Upload)
imgid=$(analysisid "$uploadinfo")
echo $imgid
imgts=$(analysistimestamp "$uploadinfo")
echo $imgts

pstinfo=$(postinfo "$imgid" "$imgts" https://ocr.wdku.net/submitOcr?type=1)
#grep '"errno":10106' <<<"$pstinfo" && exit
grep '"errno":10106' <<<"$pstinfo" && changeproxy &&  exec bash -x $0
pstid=$(analysisid "$pstinfo")
pstts=$(analysistimestamp "$pstinfo")

ocrcode=$(checkorcresponse "$pstid" https://ocr.wdku.net/waitResult2)
while [[ $ocrcode -ne 1 ]]; do
	sleep 2s
	ocrcode=$(checkorcresponse "$pstid" https://ocr.wdku.net/waitResult2)
done
#sleep 20s

responsebody=$(analysisresult "$(getresult "$pstid" "$pstts" https://ocr.wdku.net/downResult)")
#echo -n $(analysisresult "$responsebody")
printf "$responsebody"
