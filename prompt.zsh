# enable hook method
autoload add-zsh-hook

# enable and configure vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{2}●'
zstyle ':vcs_info:*' unstagedstr '%F{1}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable hg git cvs svn
zstyle ':vcs_info:*' formats "$terminfo[sgr0]%r[%F{2}%b$terminfo[sgr0]]:%S %F{1}%u%F{2}%c$terminfo[sgr0] "

function myPrompt () {
    setopt prompt_subst
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    PS1=''; RPS1=''
    PS2="↷ %_>"; RPS2=''
    PS3="↷ ?#"; RPS3=''
    PS4="↷ +i>"; RPS3=''

    local PR_SIGN_BEGIN="%B"
    if [[ "`whoami`" == 'root' ]]; then
        PR_SIGN_BEGIN+="☠"
    elif [[ "`whoami`" == 'vagrant' ]]; then
        PR_SIGN_BEGIN+="𝓥"
    elif [[ `uname -s |tr '[:upper:]' '[:lower:]'` == 'darwin' ]]; then
        PR_SIGN_BEGIN+=""
    elif [[ `uname -a |tr '[:upper:]' '[:lower:]'` == *'ubuntu'* ]]; then
        PR_SIGN_BEGIN+="u"
    elif [[ `uname -a |tr '[:upper:]' '[:lower:]'` == *'arch'* ]]; then
        PR_SIGN_BEGIN+="△"
    else
        PR_SIGN_BEGIN+="∴"
    fi
    local PR_SIGN_END="%B◯%b "

    vcs_info

    local PR_MAIN=''
    if [[ "$vcs_info_msg_0_" == "" ]]; then
      PR_MAIN+='%~'
    else
      PR_MAIN+=$vcs_info_msg_0_
    fi

    #PS1+='%{'$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]'%n@%M:%~'$terminfo[rc]'%}'
    PS1+=%(?..'[%B%F{9}%?%b]'$'\n')
    PS1+=$PR_SIGN_BEGIN' '
    PS1+=$PR_MAIN' '
    PS1+=$PR_SIGN_END

}
add-zsh-hook precmd myPrompt

function clearLine () {
  print -rn -- $terminfo[el]
}
add-zsh-hook preexec clearLine

