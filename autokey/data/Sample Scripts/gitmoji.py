from subprocess import run
c = run(['gitmoji-select', 'xdo'], capture_output=False, encoding="utf-8")
# keyboard can't send unicode (no key for that)
#keyboard.send_keys(c.stdout.rstrip())