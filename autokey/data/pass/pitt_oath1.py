x = system.exec_command('sh -c "pass  work/pitt-otp | oathtool --base32 --totp -"')
keyboard.send_keys(x)