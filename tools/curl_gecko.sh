cd $ProgramFiles/Mozilla\ Firefox/
ls -alh
firefox.exe --version
which geckodriver
cmd.exe //c geckodriver.exe -vv &
curl -vd '{"capabilities": {"alwaysMatch": {"acceptInsecureCerts": true}}}' http://localhost:4444/session
ls -alh
