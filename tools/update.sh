#!/bin/bash

cd ~/dotfiles
git pull --rebase --stat origin master

if [[ -f ~/.oh-my-zsh/tools/upgrade.sh ]]; then
	ZSH=/home/nate/.oh-my-zsh
	env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
fi

if [[ -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]]; then
	pushd ~/.oh-my-zsh/custom/themes/powerlevel9k
	git pull
	popd
elif [[ -d ~/.oh-my-zsh ]]; then
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

~/dotfiles/tools/makesymlinks.sh
