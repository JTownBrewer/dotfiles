#!/bin/sh

cd ${HOME}/dotfiles

# Install or upgrade Oh My ZSH
if [[ -f ${HOME}/.oh-my-zsh/tools/upgrade.sh ]]; then
    ZSH=${HOME}/.oh-my-zsh
    env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
else
    tools/oh-my-zsh/install.sh
fi

# Install or upgrade powerline-status
sudo pip3 install --upgrade powerline-status

# Install or upgrade PowerLevel9K
if [[ -d ${HOME}/.oh-my-zsh/custom/themes/powerlevel9k ]]; then
    pushd ${HOME}/.oh-my-zsh/custom/themes/powerlevel9k
    git pull
    popd
elif [[ -d ${HOME}/.oh-my-zsh ]]; then
    git clone https://github.com/bhilburn/powerlevel9k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel9k
fi

# take care of the configuration symlinks
${HOME}/dotfiles/tools/makesymlinks.sh
case "zsh" in ("*${SHELL}")
    source ${HOME}/.zshrc
esac
