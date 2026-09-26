output = system.exec_command("date +%Y%m%d")
keyboard.send_keys(output)

# 20240830 - send_keys types out of order in terminals (xterm, alacrity)
#            need clearmodifies show held shift after 'D' doesn't apply to virtually typed chars
#from subprocess import Popen
#x = Popen(["sh", "-c", 'xdotool type --clearmodifiers "`date +%Y%m%d`"'])
# 20260926 - with xcape shift gets held and either shift stuck down or end with '-'