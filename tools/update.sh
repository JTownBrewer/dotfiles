#!/bin/bash

cd ~/dotfiles
git pull --rebase --stat origin master

if [[ -f ~/.oh-my-zsh/tools/upgrade.sh ]]; then
	~/.oh-my-zsh/tools/upgrade.sh
fi

~/dotfiles/tools/makesymlinks.sh
