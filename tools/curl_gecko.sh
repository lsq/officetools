cmd.exe //c geckodriver.exe -vv &
curl -vd '{"capabilities": {"alwaysMatch": {"acceptInsecureCerts": true}}}' http://localhost:4444/session
