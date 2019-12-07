#coding=utf-8
from bs4 import BeautifulSoup
import requests
import re
import json

#蓝奏云分享文件链接地址
url = 'https://www.lanzous.com/i3xcmaf'

#header头，注意那个referer必须要与上面文件分享地址url相同
headers = {
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.3',
    'referer': url
}

# 获取分享页面html文件
res = requests.get(url,headers=headers)

# 引入BeautifulSoup库对html进行处理，获取iframe中的出现的js文件
soup = BeautifulSoup(res.text,'html.parser')
url2 = 'https://www.lanzous.com/'+soup.find('iframe')['src']
res2 = requests.get(url2,headers=headers)

# 正则提取请求三个参数
#a = re.findall(r'var a = \'([\w]+?)\';',res2.text)
#params = re.findall(r'var [\w]{6} = \'([\w]+?)\';',res2.text)
params = {'action':'', 'sign':'', 'ves':''}
params['action'] = re.findall(r'\'action\':\'([\w]+?)\',', res2.text)
params['sign'] = re.findall(r'\'sign\':\'([\w]+?)\',', res2.text)
params['ves'] = re.findall(r'\'ves\':\'([\w]+?)\'', res2.text)
#print(len(params))

# 请求下载地址
url3 = 'https://www.lanzous.com/ajaxm.php'
data = {
    'action': params['action'],
    'sign': params['sign'],
    'ves': params['ves'],
    #'file_id':params[0],
    #'t':params[1],
    #'k':params[2],
}
res3 = requests.post(url3,headers=headers,data=data)
res3 = json.loads(res3.content)

# 请求最终重定向地址
url4 = res3['dom']+'/file/'+res3['url']
headers2 = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0',
    'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
}
res4 = requests.head(url4, headers=headers2)
print(res4.headers['Location'])

# 作者：伤心童话
# 链接：https://juejin.im/post/5cc34961e51d456e6e389290
# 来源：掘金
# 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

#  后续调试细节
# 下载链接生成是由javascript中f_sha(f_di)生成
# 而f_sha(f_id)函数存放在https://pc.woozooo.com/includes/js/coms9.js?v7277这个文件中需要下载分析
# 以下为js代码
# function f_sha(fid){
# 	$('div#f_sha1').text('');
# 	$('div#code').text('');
# 	var url;
# 	url ='http'+ isssl +'://pan.lanzou.com/' + fid+'/';
# 	$('div#f_sha').show(150);
# 	$('div#f_sha1').text('获取中...');
# 
# 	$.ajax({
# 			type : 'post', // 发送post请求, 查询必须要附带cookie, 否则查询不成功;Response为json数据
# 			url : '/doupload.php', // https://pc.woozooo.com/doupload.php
# 			data : { 'task':22,'file_id':fid }, // Form Data: task=22&file_id=13473382
# 			dataType : 'json',
# 			success:function(msg){
# 				if(msg.zt == '1'){
# 					//success
# 					if(msg.info.onof ==1){
# 						//on
# 						url =msg.info.is_newd +'/' + msg.info.f_id +'<br>密码:'+msg.info.pwd + msg.info.taoc;
# 						//urls ='http'+ isssl +'://pan.lanzou.com/' + msg.info.f_id;
# 						url_d = msg.info.is_newd+'/'+msg.info.f_id;
# 						code_suc(url_d);
# 						$('div#f_sha1').html(url);
# 					}else{
# 						//无密码
# 						//t.cn
# 						//tcn(msg.info.f_id); 
#                                               // info.is_newd: "https:\/\/www.lanzous.com"是返回的请求host;
#                                               // info.f_id: "i7t3s9g"是返回请求路径;
#                                               // taoc: "";
# 						url =msg.info.is_newd +'/' + msg.info.f_id + msg.info.taoc;
# 						//urls ='http'+ isssl +'://pan.lanzou.com/' + msg.info.f_id;
# 						url_d = msg.info.is_newd+'/'+msg.info.f_id;
# 						code_suc(url_d);
# 						$('div#f_sha1').html(url);
# 					}
# 					url = msg.info.is_newd + '/' + msg.info.f_id;
# 				}else{
# 					w_info('获取失败，请重试');
# 				}
# 			},
# 			error:function(){
# 				w_info('获取失败，请重试');
# 			}
# 	
# 		});
# 
# }
