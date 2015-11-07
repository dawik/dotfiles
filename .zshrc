export TERM='linux'
export PS1='$(path) %% '
export ERL_LIBS=/home/dave/erl_libs
export PATH=$PATH:$HOME/bin
HISTFILE=~/.histfile
HISTSIZE=1000000000000000000
SAVEHIST=1000000000
bindkey -v
zstyle :compinstall filename '/home/davve/.zshrc'
autoload -Uz compinit
compinit
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac
autoload -U zmv
alias mmv='noglob zmv -W'
set directory=tmp,/tmp
alias vi=vim
alias ls='ls --color=auto'
sprunge() { curl -F 'sprunge=<-' http://sprunge.us < "${1:-/dev/stdin}"; }
xset q | grep -A 0 Pointer > /dev/null
xset m 0 10
titlepath()
{
     cd $1
     echo -ne "\033]0;$(path)\007"
}
alias cd=titlepath
titlepath ~
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
