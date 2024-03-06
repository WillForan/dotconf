from subprocess import run
c = run(['rofi', '-modi', 'emoji', '-show', 'emoji', '-emoji-format', '{emoji}:{name}/{keywords}'], capture_output=False, encoding="utf-8")