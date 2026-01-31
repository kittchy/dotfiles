# 様々なツールをこちらで呼び出す

function command_exist(){
  if type $1 > /dev/null 2>&1; then
    echo true
  else
    echo false
  fi
}

function detect_os () {
  if [[ `uname` == 'Darwin' ]]; then
    echo 'mac'
  elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]] then
    RELEASE_FILE=/etc/os-release
    if grep '^NAME="CentOS' $RELEASE_FILE >/dev/null; then
      echo 'centos'
    elif grep '^NAME="Ubuntu' $RELEASE_FILE >/dev/null; then
      echo 'ubuntu'
    else
      echo "Your platform is not supported."
      exit 1
    fi
  elif [[ "$(expr substr $(uname -s) 1 6)" == 'CYGWIN' ]]; then
    echo 'cygwin'
  else
    echo "Your platform is not supported."
    exit 1
  fi
}

export PATH=$PATH:$HOME/tools/bin

OS=$(detect_os)
