keyboard.send_keys("foranw@upmc.edu\t")

# todo: run password
output = system.exec_command("pass work/upmc")
keyboard.send_keys(output)

import subprocess
x = subprocess.Popen(["sh", "-c", 'pass work/upmc-otp | oathtool -b |xclip -i -selection clipboard'])