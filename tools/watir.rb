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
