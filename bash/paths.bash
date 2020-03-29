#
# PATHS mostly for things not handled by the package manager
#

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/src/utils/plum:$PATH"
# pyenv setup if we have pyenv
command -v pyenv >/dev/null && {
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   eval "$(pyenv init -)"
}

# cpanm setup w/ local::lib if we have lib dir in home
test -d $HOME/perl5/lib/perl5 && eval $(perl -I $_ -Mlocal::lib)

# org export
export PATH="$PATH:$HOME/src/utils/org-export"
# work functions (mkifdiff, mkls, mkstat, m, etc)
export PATH="$PATH:$HOME/src/work/lncdtools"

# matrix_decrypt, matrix_sso_helper, and matrix_upload
test -d /usr/lib/weechat/python/matrix/contrib/ &&
   export PATH="$PATH:$_"

# garmin connect IQ unzipped SDK
test -d $HOME/src/cIQ/bin && export PATH="$PATH:$_"
