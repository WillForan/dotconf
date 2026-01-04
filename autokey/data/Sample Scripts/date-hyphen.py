#output = system.exec_command("date +%F")
#keyboard.send_keys(output)
from subprocess import Popen
x = Popen(["sh", "-c", 'xdotool type --clearmodifiers "`date +%Y-%m-%d`"'])