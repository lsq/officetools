#!/usr/bin/env python
# need install Microsoft Edge driver
# pip install msedge-selenium-tools
from msedge.selenium_tools import Edge, EdgeOptions

# Launch Microsoft Edge (EdgeHTML)
#driver = Edge()

# Launch Microsoft Edge (Chromium)
options = EdgeOptions()
options.use_chromium = True
options.add_argument("--explicitly-allowed-ports=22")
driver = Edge(options = options)

url= "http://120.78.128.29:22/k3cloud/html5/index.aspx"
driver.get(url)
