. $HOME/.config/zsh/sync/utils.zsh

# ls系
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
if $(command_exist lsd); then
  alias ls='lsd -h '
  alias ll='lsd -hAlF'
  alias la='lsd -ah'
  alias l='clear && lsd -h'
fi

# top系
if $(command_exist btop); then
  alias top='btop'
  alias htop='btop'
fi

# cd 
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

# zsh
alias zshref='clear && source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'
alias zshrc_extention='nvim ~/.zsh.extentions'
alias zshrc_local='nvim ~/.local.zsh'

# cat
if $(command_exist bat); then
    alias cat="bat"
fi

# diff
if $(command_exist delta); then
    alias diff="delta"
fi

# find
# alias fd="fdfind"

alias tar_unzip='tar -zxvf'
alias tar_zip='tar -zcvf'
alias tar_scp='tar_scp_func'

# nvim 
alias nvimrc="nvim ~/.config/nvim/init.vim"

# gpp
alias gpp='g++ -Wall -O3 -std=c++17 -I/usr/local/include']

if [[ $OS == 'mac' ]]; then
  # window manager
  function reload_macos_window () {
      skhd --restart-service
      yabai --restart-service
      brew services restart sketchybar
  }
  alias reload_window="reload_macos_window"
  
  function start_macos_window () {
      skhd --start-service
      yabai --start-service
      brew services start sketchybar
  }
  alias start_window="start_macos_window"
  
  function stop_macos_window () {
      skhd --stop-service
      yabai --stop-service
      brew services stop sketchybar
  }
  alias stop_window="stop_macos_window"
elif [[ $OS == 'ubuntu' ]]; then
  # apt
  alias apt="sudo apt-fast"
fi


## lazygit
alias lg="lazygit" 

## git
# alias gc="git checkout"
# alias gs="git switch"
# alias gb="git branch"
# alias gp="git pull"
# alias gm="git merge"

# docker exec
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'
# ssh 
alias sshlist="cat ~/.ssh/config |grep ^Host\  |sed -e 's/^Host\ //g'"
alias pssh="sshlist | peco | xargs -I{} sh -c 'ssh {} </dev/tty' ssh"

# latex
alias tex-clear-cache='latexmk -c'
alias tex-clear-cache-all='latexmk -C'
alias tex-auto='latexmk -pdfdvi -pvc -interaction=nonstopmode'
alias tex-count='texcount -inc -sum -1'

# fzf
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt print_eight_bit

## history fuzzy find
## fzf history
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^f' fzf-select-history

function fzf-select-alias() {
    eval $(alias | grep -Ev 'base16|otherword' | sort | fzf | sed -e 's/=.*$//')    
}
zle -N fzf-select-alias
bindkey '^r' fzf-select-alias

## fzf cdr
function fzf-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --reverse)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-cdr
setopt noflowcontrol
bindkey '^q' fzf-cdr

## zellij
alias zj="zellij -l welcome"
alias zja="zellij attach"
alias tmux="echo tmuxよりzellijを使うようにしましょう。zjにエイリアスをはってます。"

# PDF圧縮
function pdfmin()
{
    local cnt=0
    for i in $@; do
        gs -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.4 \
           -dPDFSETTINGS=/ebook \
           -dNOPAUSE -dQUIET -dBATCH \
           -sOutputFile=${i%%.*}.min.pdf ${i} &
        (( (cnt += 1) % 4 == 0 )) && wait
    done
    wait && return 0
}

function dbt_test_func()
{
    project_path=$1

    echo "poetry run dbt run --profiles-dir profiles --vars \"$(yq . vars/dev.yml)\" --select $project_path"
    poetry run dbt run --profiles-dir profiles --vars "$(yq . vars/dev.yml)" --select $project_path
    echo "poetry run dbt test --profiles-dir profiles --vars \"$(yq . vars/dev.yml)\" --select $project_path"
    poetry run dbt test --profiles-dir profiles --vars "$(yq . vars/dev.yml)" --select $project_path
    echo "poetry run dbt-osmosis yaml refactor --vars \"$(yq . vars/dev.yml)\" --profiles-dir profiles --force-inheritance $project_path"
    poetry run dbt-osmosis yaml refactor --vars "$(yq . vars/dev.yml)" --profiles-dir profiles --force-inheritance $project_path
}
alias dbt_test='dbt_test_func'

# json
function analyze_json_func {
    json_file=$1
    jq -r 'def tree: paths(scalars) as $p | $p | map(if type == "number" then "[]" else tostring end) | join("/"); tree' $json_file | sort -u | sed 's|^|/|' | tree --fromfile
}

alias analyze_json='analyze_json_func'

# # claude
alias claude="SHELL=/bin/sh claude"

# 遊び
alias aa="asciiquarium"
alias clock="tty-clock -sc"
