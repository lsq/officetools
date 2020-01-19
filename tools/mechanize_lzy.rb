require 'mechanize'
require 'pry'
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'
page = agent.get('https://up.woozooo.com/account.php?action=login&ref=/mydisk.php')
page.form_with(name:'user_form')
loginform = page.form_with(name:'user_form')
#if File.exist?("cookies.yaml")
  #agent.cookie_jar.load("cookies.yaml")
  puts "rewrite now...."
# else
loginform.username = '13113602265'
loginform
loginform.password = 'x'
loginform
agent.submit(loginform,loginform.button_with(value:'登 陆'))
agent.cookie_jar.save("cookies.yaml", session: true)
loginpage = agent.submit(loginform,loginform.button_with(value:'登 陆'))
#end

# screen-scrapey stuff
#agent.cookie_jar.save("cookies.yaml")
#But you can override this behavior with an option:

#agent.cookie_jar.save("cookies.yaml", session: true)
# With the session flag set, Mechanize will write out the full contents of its cookie jar for later loading.
#puts loginpage.link_with(text:/Lanzou/)
mainframe = loginpage.link_with(text:/登录/).click.iframe('mainframe')
rootfile = mainframe.click.iframe('mainframe').click
rtfile_form = rootfile.form('file_form')
puts rtfile_form
rtfile_form = rootfile.form('file_form')
host= 'https://pc.woozooo.com/'
# I could solve this by adding the cookies before submitting the form.
# cookie = Mechanize::Cookie.new(name: '#{name}', value: '#{value}', domain: '#{domain}', path: '/')
# agent.cookie_jar.load(cookie)

# https://stackoverflow.com/questions/18593380/store-login-session-cookie-in-browser-using-ruby-mechanize
# agent.post(host+"/"+ rtfile_form.action, {item: 'files', action: 'index', u:'1311360225'})
agent.cookie_jar.load("cookies.yaml")
agent.post(host+"/"+ rtfile_form.action, { action: 'index', u:'1311360225'})

binding.pry
puts "finished!!"
