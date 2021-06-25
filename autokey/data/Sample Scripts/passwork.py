output = system.exec_command("pass work/upmc")
keyboard.send_keys(output)

import subprocess
x = subprocess.Popen(["sh", "-c", '/home/foranw/bin/upmc_mfa|xclip -i -selection clipboard'])