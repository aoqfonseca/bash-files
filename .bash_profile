# Make bash check its window size after a process completes
shopt -s checkwinsize

# LS COLORS
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# ENVIRONMENT

# GREP
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;37'
alias grep='grep --color=auto' # Always highlight grep search term

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_branch_with_brackets() {
  typeset current_branch=$(parse_git_branch)
  if [ "$current_branch" != "" ]
  then
      echo "($current_branch)"
  fi
}

parse_hg_branch_with_brackets() {
  hg branch 2> /dev/null | awk '{print "("$1")"}'
}

parse_current_rvm() {
  typeset current_rvm=`rvm current i v`
  if [ "$current_rvm" != "system" ]
  then
      echo "($current_rvm) "
  fi
}


# Setting PATH for MacPython 2.5, 2.6 and 2.7
PYTHON_VERSIONS_PATH="/Library/Frameworks/Python.framework/Versions"
PATH="$PYTHON_VERSIONS_PATH/Current/bin:$PYTHON_VERSIONS_PATH/2.5/bin:$PYTHON_VERSIONS_PATH/2.6/bin:$PYTHON_VERSIONS_PATH/2.7/bin:${PATH}"
export PATH

# 30m - Black
# 31m - Red
# 32m - Green
# 33m - Yellow
# 34m - Blue
# 35m - Purple
# 36m - Cyan
# 37m - White
# Everything else is green...
# 0 - Normal
# 1 - Bold
# 2 - 
function prompt {
	local BLACK="\[\033[0;30m\]"
	local RED="\[\033[0;31m\]"
	local GREEN="\[\033[0;32m\]"
	local YELLOW="\[\033[0;33m\]"
	local BLUE="\[\033[0;34m\]"
	local PURPLE="\[\033[0;35m\]"
	local CYAN="\[\033[0;36m\]"
	local WHITE="\[\033[0;37m\]"
	local WHITEBOLD="\[\033[1;37m\]"
    export PS1="${WHITE}\$(parse_current_rvm)${WHITEBOLD}\u${RED} at ${WHITEBOLD}\h ${RED}in ${GREEN}\w ${WHITE}\$(parse_git_branch_with_brackets)${WHITE}\$(parse_hg_branch_with_brackets)
${YELLOW}$ \[\e[m\]\[\e[m\]"
}
prompt

export VIRTUALENVWRAPPER_PYTHON=`which python`
source `which virtualenvwrapper.sh`
[[ -s "/Users/francisco.souza/.rvm/scripts/rvm" ]] && source "/Users/francisco.souza/.rvm/scripts/rvm"  # This loads RVM into a shell session.



function rails {
  if [ -e script/rails ]; then
    script/rails $@
  else
    `which rails` $@
  fi
}

function rake {
  if [ -e Gemfile ]; then
    bundle exec rake $@
  else
    `which rake` $@
  fi
}

function heroku {
  if [ -e Gemfile ]; then
    bundle exec heroku $@
  else
    `which heroku` $@
  fi
}

function rspec {
  if [ -e Gemfile ]; then
    bundle exec rspec $@
  else
    `which rspec` $@
  fi
}

