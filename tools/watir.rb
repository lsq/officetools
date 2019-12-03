#!/usr/bin/env ruby -w
# encoding: utf-8

require 'watir'


profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = 'C:\Users\Administrator\Downloads'
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
browser = Watir::Browser.new :firefox, profile: profile

browser.goto 'http://www.lanzou.com/u'
# browser.link(text: 'Guides').click

puts browser.title
# => 'Guides – Watir Project'
# browser.close
username = browser.text_field id: 'username'
username.exists?
username.set '13113602665'
username.value