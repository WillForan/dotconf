hs.loadSpoon("ClipboardTool")
spoon.ClipboardTool:bindHotkeys({
  toggle_clipboard = {{"cmd", "shift"}, "v"}
})
spoon.ClipboardTool.paste_on_select = true
spoon.ClipboardTool.show_in_menubar = true
spoon.ClipboardTool.hist_size = 500
spoon.ClipboardTool:start()

