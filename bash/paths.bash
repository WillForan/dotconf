#
# PATHS 
#  - utils not yet packaged
#  - language modules: python (pyenv), perl (cpanm), node (npm)
#

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/src/utils/plum:$HOME/src/utils/dynamic-colors/bin:$PATH"

# ruby gems (for xiki -- but that was 2012 version!) 20200531
test -d "$HOME/.gem/ruby" && {
 # ls -d "$HOME/.gem/ruby"/*/bin|sed -n '$p'
 _rubiesbin=("$HOME/.gem/ruby/"*/bin)
 PATH="$PATH:${_rubiesbin[${#_rubiesbin}]}"
}
# 20200531 xiki from git (no gem install)
test -d "$HOME/src/utils/xiki/bin" && PATH="$PATH:$_"

# 20221107 rust cargo
test -d  "$HOME/.cargo/bin" &&
  PATH="$PATH:$_"

# pyenv setup if we have pyenv
# pyenv is very slow. replace with the exports it produced
 command -v pyenv >/dev/null && {
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   [ -n "${USEPYENVINIT:-}" ] && {
      eval "$(pyenv init --path)"
      eval "$(pyenv init -)"
   }
}

# cpanm setup w/ local::lib if we have lib dir in home
# perl -I is slowest thing in bashrc. repace with what it actually does
#test -d $HOME/perl5/lib/perl5 && eval $(perl -I $_ -Mlocal::lib)
test -d "$HOME/perl5/lib/perl5" && {
  export PERL_MB_OPT="--install_base \"$HOME/perl5\""
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
}

# things that might exist
for d in \
 /usr/lib/weechat/python/matrix/contrib/ `# matrix_decrypt, matrix_sso_helper, and matrix_upload` \
 $HOME/src/utils/org-export   `# github pages: willforan.github.io `\
 $HOME/src/work/lncdtools     `# work functions (mkifdiff, mkls, mkstat, m, etc)` \
 /opt/ni_tools/afni           `# NIMH nueroimaging` \
 /opt/ni_tools/fmri_processing_scripts  \
 /opt/ni_tools/c3d/bin \
 /opt/ANTs/bin\
 /opt/ni_tools/mrpeek\
 /opt/ni_tools/lncdtools\
 $HOME/src/cIQ/bin            `# garmin connect IQ unzipped SDK` \
 /usr/share/perl6/vendor/bin/ `# raku/perl6 for zef`\
 ; do
   test -d "$d" && PATH="$PATH:$d"
done
export PATH

# 20200408
# only needs to happen once. slow to run. grep first to check
! grep prefix= ~/.npmrc  -q 2>/dev/null && command -v npm >/dev/null && npm config set prefix ~/.local
export NODE_PATH="$HOME/.local/lib/node_modules:$NODE_PATH"
export PATH=$PATH:/opt/afni/

# 20230909 radicle git "souvenir forge"
# installed with https://radicle.xyz/install
test -d "$HOME/.radicle/bin" && PATH="$PATH:$_"

# 20230620 rash-repl
export PATH="$PATH:$HOME/.local/share/racket/8.9/bin/"


# 20211002 - want auto updates from zotero and firefox
test -r "$HOME/bin/firefox" && export PATH="$_:$PATH"
test -r "$HOME/bin/zotero" && export PATH="$_:$PATH"


