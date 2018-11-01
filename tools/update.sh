#!/bin/bash

cd ~/dotfiles
git pull --rebase --stat origin master

if [[ -f ~/.oh-my-zsh/tools/upgrade.sh ]]; then
	ZSH=/home/nate/.oh-my-zsh
	env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
fi

~/dotfiles/tools/makesymlinks.sh
