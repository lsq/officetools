cd "%ProgramFiles%\Mozilla Firefox\"
ls -alh
firefox.exe --version
which geckodriver
start cmd.exe /k "geckodriver.exe -vv "
curl -vd '{"capabilities": {"alwaysMatch": {"acceptInsecureCerts": true}}}' http://localhost:4444/session
pwd
ls -alh
