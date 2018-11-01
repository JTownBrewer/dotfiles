#!/bin/bash

cd ~/dotfiles
git pull --rebase --stat origin master

if [[ -f ~/.oh-my-zsh/tools/upgrade.sh ]]; then
	env ZSH=/home/nate/.oh-my-zsh sh $ZSH/tools/upgrade.sh
fi

~/dotfiles/tools/makesymlinks.sh
