#
# PATHS 
#  - utils not yet packaged
#  - language modules: python (pyenv), perl (cpanm), node (npm)
#

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/src/utils/plum:$PATH"

# ruby gems (for xiki -- but that was 2012 version!) 20200531
command -v ruby >/dev/null &&
 PATH="$PATH:$(ls -d $HOME/.gem/ruby/*/bin|sed -n '$p')"
# 20200531 xiki from git (no gem install)
test -d $HOME/src/utils/xiki/bin && PATH="$PATH:$_"

# pyenv setup if we have pyenv
command -v pyenv >/dev/null && {
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   eval "$(pyenv init -)"
}

# cpanm setup w/ local::lib if we have lib dir in home
test -d $HOME/perl5/lib/perl5 && eval $(perl -I $_ -Mlocal::lib)

# things that might exist
for d in \
 /usr/lib/weechat/python/matrix/contrib/ `# matrix_decrypt, matrix_sso_helper, and matrix_upload` \
 $HOME/src/utils/org-export `# github pages: willforan.github.io `\
 $HOME/src/work/lncdtools   `# work functions (mkifdiff, mkls, mkstat, m, etc)` \
 /opt/ni_tools/afni         `# NIMH nueroimaging` \
 $HOME/src/cIQ/bin          `# garmin connect IQ unzipped SDK` \
 ; do
   test -d "$d" && PATH="$PATH:$d"
done
export PATH

# 20200408
# only needs to happen once. slow to run. grep first to check
grep prefix= ~/.npmrc  -q 2>/dev/null || npm config set prefix ~/.local
export NODE_PATH="$HOME/.local/lib/node_modules:$NODE_PATH"
export PATH=$PATH:/opt/afni/
