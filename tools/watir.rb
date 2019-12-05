#!/usr/bin/env ruby -w
# encoding: utf-8

require 'watir'


profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = 'C:\Users\Administrator\Downloads'
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
browser = Watir::Browser.new :firefox, profile: profile

#browser.goto 'http://www.lanzou.com/u'
browser.goto 'https://up.woozooo.com/account.php?action=login&ref=/mydisk.php'
# browser.link(text: 'Guides').click

puts browser.title
# => 'Guides – Watir Project'
# browser.close
username = browser.text_field(id: 'username') if browser.text_field(name: 'username').exists?
# username.exists?
username.set '13113602665'
password = browser.text_field(name: 'password') if password = browser.text_field(name: 'password').exists?
password.set('xx')
#button = browser.element(id:'s3')
browser.element(id:'s3').click
#username.value
# https://blog.csdn.net/weixin_34209406/article/details/90122639
# 在 Watir 的 Wiki 上, Watir 中识别各种 HTML 对象
# test form inside iframe
browser.iframe(id:'mainframe').form(name:'file_form').exists?
browser.iframe(id:'mainframe').form(name:'file_form').link(text: /v2rayN_2.29.7z/).exists?
browser.iframe(id:'mainframe').form(name:'file_form').link(text: /v2rayN_2.29.7z/).click
# 点击下载href后会弹出一个空标题窗口，需要关闭
# http://watir.com/guides/windows/
# 查看由browser生成的所有窗口 https://github.com/watir/watirspec/blob/master/window_switching_spec.rb
browser.windows
browser.windows[0].title
browser.windows[1].title
b_empty = browser.windows[1].use if empty(browser.windows[1].title)
b_empty.close
# 下载链接
## ifram里面的form
browser.iframe(id:'mainframe').div(id:'f_sha').exists?
dataform=browser.iframe(id:'mainframe').form(name:'file_form')
## 下载链接与二维码区域
dldiv = browser.iframe(id:'mainframe').div(id:'f_sha')
# 实际下载链接
dldiv.div(id:'f_sha1').text
# 文件夹列表
dataform.div(id:'sub_folder_list').text
# 文件列表 包括文件大小、上传时间等信息
dataform.div(id:'filelist').text
# 仅包含文件名
dataform.div(id:'filelist').div(class:'f_name').text

# 文件夹点击，进入子目录
dataform.div(id:'sub_folder_list').link(text:/tool/).click
# get full file list
dataform.div(id:'filemore').exists?
dataform.div(id:'filelist').text
dataform = browser.iframe(id:'mainframe').form(name: 'file_form')
dldiv = browser.iframe(id:'mainframe').div(id:'f_sha1')
=begin
=== 判断div在是否存在a标签 https://bbs.csdn.net/topics/310257240
window.onload = function() {
        var count = 0;
        var div = document.getElementById("div1");
        var len = div.childNodes.length;
        for (var i = 0; i < len; i++) {
            if (div.childNodes[i].nodeName.toLowerCase() == "a") {
                count++;
            }
        }
        alert("div1中存在"+count+"个<a>");
    }

function existOrNot(){
var obj,array;
obj=document.getElementById("sc2");
array=obj.getElementsByTagName("a");
if(array.length>0){
alert("存在a!");}
else{alert("不存在a!");}
}

=== links 
http://www.zhangxinxu.com/study/201004/http-link-auto-able-demo.html
http://www.zhangxinxu.com/wordpress/2010/04/javascript%E5%AE%9E%E7%8E%B0http%E5%9C%B0%E5%9D%80%E8%87%AA%E5%8A%A8%E6%A3%80%E6%B5%8B%E5%B9%B6%E6%B7%BB%E5%8A%A0url%E9%93%BE%E6%8E%A5/
<script type="text/javascript">
                    var $ = function(id){
                        return document.getElementById(id);
                    };
                    $("btn").onclick = function(){
                        var v = $("txt").value;
                        var reg = /(http:\/\/|https:\/\/)((\w|=|\?|\.|\/|&|-)+)/g;
                        v = v.replace(reg, "<a href='$1$2'>$1$2</a>").replace(/\n/g, "<br />");
                        $("show").innerHTML = v;
                    };
                </script>
				
=== 原文链接：https://blog.csdn.net/qq_38543537/article/details/84562209

//链接可点击
    if($('.thread_mess').length){
        var textR=$('.thread_mess').html();
        var reg = /(http:\/\/|https:\/\/)((\w|=|\?|\.|\/|&|-)+)/g;
        var imgSRC=$('.thread_mess img').attr('src');
        if(reg.exec(imgSRC)){
            return false
        }else{
          textR = textR.replace(reg, "<a href='$1$2'>$1$2</a>");
        }
        document.getElementById('thread_imgid').innerHTML = textR;
		}

browser.execute_script("document.getElementById('f_sha1').innerHTML = '<a href=\"www.baidu.com\"> aa </a>';alert(document.getElementById('f_sha1').innerHTML);alert(document.getElementById('f_sha1').innerHTML); alert(document.getElementById('f_sha1').innerHTML);")

=end
script = %Q(
var $ = function(id){
	return document.getElementById(id);
};
//alert(arguments[0]); 
var el_id = arguments[0]; 
//alert( $(el_id).innerHTML);
//alert( $(el_id).innerHTML.length);
if($(el_id).innerHTML.length){
        var textR=$(el_id).innerHTML;
//	alert(textR);
        var reg = /(http:\\/\\/|https:\\/\\/)((\\w|=|\\?|\\.|\\/|&|-)+)/g;
//	alert(reg);
        var a_array=$(el_id).getElementsByTagName("a");
/*
	https://bbs.csdn.net/topics/310257240
*/
        if(a_array.length){
//	    alert(a_array.length);
            return false
        }else{
          textR = textR.replace(reg, "<a href='$1$2' target='view_windowk'>$1$2</a>");
        }
        $(el_id).innerHTML = textR;
	
})
# 注入javascript脚本
browser.execute_script(script, dldiv.id)
# 点击下载链接
dldiv.link.click(:control)
# 跳转到新的标签节
browser.windows[1].use
# 下载窗口中电信链接
browser.iframe(class:'ifr2').exists?
browser.iframe(class:'ifr2').span(text: '电信下载').click
# https://www.cnblogs.com/gcgc/p/11326333.html
# 自动化测试，破解验证码完整记录
# 定位到该元素，获取位置信息
browser.img(id:'img').location
browser.img(id:'img').location['x']
browser.img(id:'img').location['y']
browser.screenshot.save 'screen.png'
# 蓝奏云爬虫链接
# https://blog.csdn.net/lzz781699880/article/details/81906070
# https://blog.csdn.net/weixin_42567389/article/details/90312791
# https://blog.csdn.net/weixin_34281477/article/details/91417249
