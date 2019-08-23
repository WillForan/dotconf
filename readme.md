# dot config files for common apps
## usage/install
see `install.bash`

 - from https://github.com/WillForan/ clones depend
   * `wf-utils`  - short scripts for i3 and xbindkeys shortcuts
   * `fuzzy_args` - bash history and new files (.bashrc)
   * `plum` - plan9 like plumber referenced in xbindkeys, easystroke
 - ln installs .bashrc
 - stow installs vim, x11 user files, xbindkeys, etc

# Notes
* wf-utils 
  * i3 (jumpback within monitor, swap monitor workspaces)
  * xbindkeys - i3, zim, playerctrl, pidgin
* `sp` bash sshpass function looks in `~/passwd/ssh/` for hosts likely defined in `.ssh/config`
* bash <kbd>alt+L</kbd> changes terminal colors using [`dynamic-colors`](https://github.com/sos4nt/dynamic-colors)
* passhole `ph` is used to access keepass file stored next to ssh passwords
