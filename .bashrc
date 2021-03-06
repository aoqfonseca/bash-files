# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w
    \[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w
    \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_hg_branch() {
  hg branch 2> /dev/null | awk '{print $1}'
}

parse_git_branch_with_brackets() {
  typeset current_branch=$(parse_git_branch)
  if [ "$current_branch" != "" ]
  then
      echo "($current_branch)"
  fi
}

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
    export PS1="${WHITE}\u${RED}@${PURPLE}\h ${CYAN}\w ${WHITE}\$(parse_git_branch_with_brackets)${WHITE}\$(parse_hg_branch)
${YELLOW}$ \[\e[m\]\[\e[m\]"
}

prompt

echo -e ""
echo -ne "Today is "; date
echo -e ""; cal;
echo -ne "Up time: ";uptime | awk /'up/ {print $3,$4}'
echo "";

export GAE=/usr/local/google_appengine
export GAE_USR=$GAE/lib

export JYTHONPATH=$HOME/jython
export PYTHONPATH=$GAE:$GAE_USR/yaml/lib/:$PYTHONPATH:$GAE_USR/webob:$GAE_USR/antlr3:$GAE_USR/ipaddr:$GAE_USR/cacerts
export ANDROID=/usr/local/android_sdk
export PATH=$PATH:$JYTHONPATH/bin:$GAE:$ANDROID/tools:$HOME/local/bin

source /usr/local/bin/virtualenvwrapper.sh

function work () {
    typeset env_name="$1"
    if [ "$env_name" = "" ]
    then
        virtualenvwrapper_show_workon_options
        return 1
    fi

    virtualenvwrapper_verify_workon_environment $env_name || return 1

    echo "source ~/.profile
          workon $env_name" > ~/.virtualenvrc

    bash --rcfile ~/.virtualenvrc
}

export JAVA_HOME=/usr/lib/jvm/java-6-sun
export CATALINA_HOME=$HOME/Applications/apache-tomcat-6.0.29
export M2_HOME=/usr/local/apache-maven-3.0.1
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$JAVA_HOME/bin:$PATH
export JAVA_OPTS="-Dpython.home=$HOME/jython"

# Push git changes. $1 = destination branch
function git_push() {
    typeset current_branch=$(parse_git_branch)
    typeset destination_branch="$1"
    if [ "$destination_branch" = "" ]
    then
        typeset destination_branch="master"
    fi
    git pull origin $destination_branch && git checkout $destination_branch && git merge $current_branch && git push origin $destination_branch && git checkout $current_branch
}
