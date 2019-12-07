require 'mechanize'
agent = Mechanize.new
page = agent.get('https://up.woozooo.com/account.php?action=login&ref=/mydisk.php')
page.form_with(name:'user_form')
loginform = page.form_with(name:'user_form')
loginform.username = '13113602265'
loginform
loginform.password = 'x'
loginform
loginpage = agent.submit(loginform,loginform.button_with(value:'登 陆')
)
loginpage.link_with(text:/Lanzou/)
loginpage.link_with(text:/Lanzou/).click
loginpage
loginpage.link_with(text:/'登录'/).click
loginpage.link_with(text:/登录/).click
loginpage
mainframe = loginpage.link_with(text:/登录/).click.frame('mainframe')
mainframe
loginpage.link_with(text:/登录/).click.frame('mainframe')
loginpage
loginpage.link_with(text:/登录/).click
loginpage.link_with(text:/登录/).click.frame('mainframe')
loginpage.link_with(text:/登录/).click.iframe('mainframe')
mainframe = loginpage.link_with(text:/登录/).click.iframe('mainframe')
mainframe.click
mainframe.click.iframe('mainframe').click
rootfile = mainframe.click.iframe('mainframe').click
rtfile_form = rootfile.form('file_form')
rtfile_form = rootfile.form('file_form').click
rtfile_form = rootfile.form('file_form').link
rtfile_form = rootfile.form('file_form').links
rtfile_form = rootfile.form('file_form').action
rtfile_form = rootfile.form('file_form').action.click
rtfile_form
rtfile_form = rootfile.form('file_form')
host= 'https://pc.woozooo.com/'
agent.post(host+"/"+ rtfile_form.action, {item: 'files', action: 'index', u:'1311360225'})
agent.post(host+"/"+ rtfile_form.action, { action: 'index', u:'1311360225'})
