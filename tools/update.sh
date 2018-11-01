#!/bin/bash

git pull --rebase --stats ~/dotfiles

if [[ -f ~/.oh-my-zsh/tools/upgrade.sh ]]; then
	~/.oh-my-zsh/tools/upgrade.sh
fi

~/dotfiles/tools/makesymlinks.sh
