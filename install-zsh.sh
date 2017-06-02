#!/bin/bash

install_zsh () {
  if [[ ! -d $dir/oh-my-zsh/ ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
}

install_zsh
