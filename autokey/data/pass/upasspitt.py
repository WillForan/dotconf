keyboard.send_keys("foran@pitt.edu\t")

# todo: run password
output = system.exec_command("pass work/pitt")
keyboard.send_keys(output)

import subprocess
x = subprocess.Popen(["sh", "-c", 'pass  work/pitt-otp | oathtool --base32 --totp -|xclip -i -selection clipboard'])
