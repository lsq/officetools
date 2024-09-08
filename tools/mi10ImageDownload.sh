set -x
basedir=$(realpath ${0%/*})
cd $basedir
miCode="$1"
case $miCode in
	"cmi")
	miDownloadUrl="https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V11.0.18.0.QJACNXM/cmi_images_V11.0.18.0.QJACNXM_20200519.0000.00_10.0_cn_5f67590a81.tgz"
	miName="mi 10 Pro"
	;;
	"thyme")
	miDownloadUrl="https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V14.0.6.0.TGACNXM/thyme_images_V14.0.6.0.TGACNXM_20230904.0000.00_13.0_cn_c97bf99cf1.tgz"
	miName="mi 10S"
	;;
	*)
	echo "没有输入正确的小米代码号！"
	exit 1
	;;
esac
miImage="$miCode"_images
echo "scoop uninstall aria2 ;scoop install main/aria2;scoop install notepad3-pre" >> ./install-scoop.ps1
powershell ".\install-scoop.ps1"
export PATH="$USERPROFILE/scoop/shims":$PATH
aria2c "--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.61 Chrome/126.0.6478.61 Not/A)Brand/8  Safari/537.36" --allow-overwrite=true --auto-file-renaming=false --retry-wait=4 --split=16 --max-connection-per-server=16 --min-split-size=4M  --no-conf=true --follow-metalink=true --metalink-preferred-protocol=https  --continue --summary-interval=0 --auto-save-interval=1 -d ./  -o "$miImage".tgz "$miDownloadUrl"
tar xf "$miImage".tgz
mkdir img
[ -d `echo ${miImage}_*` ] && imgdir=$(echo ${miImage}_*) || exit 1
cp $imgdir/images/{boot,recovery,vbmeta}.img ./img
releaseLog="$miName $imgdir
\* boot.img
\* recovery.img
\* vbmeta.img
"
echo "$releaseLog" | sed -e ':a;N;$!ba;s/\n/\\n/g' > $basedir/../gitlog.txt
#git clone https://github.com/cfig/Android_boot_image_editor.git
#pacman -Sy dtc zip vim --noconfirm
#export PATH=/c/Program\ Files/Java/jdk21/bin:$PATH
#export JAVA_HOME=/c/Program\ Files/Java/jdk21
#cp $imgdir/images/{boot,recovery,vbmeta}.img Android_boot_image_editor/
#cd Android_boot_image_editor
#./gradlew unpack
#ls -al
