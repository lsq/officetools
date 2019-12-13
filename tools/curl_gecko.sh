env
cd "$PROGRAMFILES\Mozilla Firefox"
ls -alh
cmd //c ".\firefox.exe --version"
which geckodriver
# cmd //c start cmd.exe /k "geckodriver.exe -vv "
cmd //c geckodriver.exe -vv &
sleep 10s
# curl -vd "{\"capabilities\": {\"alwaysMatch\": {\"acceptInsecureCerts\": true}}}" http://localhost:4444/session
curl -v -d '{"capabilities": {"alwaysMatch": {"acceptInsecureCerts": true,"moz:firefoxOptions": {"args": ["-headless"], "prefs": {"dom.ipc.processCount": 8}, "log":{"level": "trace"}}}}}' http://localhost:4444/session
pwd
ls -alh
