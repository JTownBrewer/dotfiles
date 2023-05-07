#!/bin/bash

get_os_info() {
    if [ -f /etc/os-release ]; then
        #freedesktop.org and systemd
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=debian
        VER=$(cat /etc/debian_version)
#    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
    ...
#    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
    ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

cd ${HOME}/dotfiles

# Update ourselves
#git reset --hard > /dev/null
#git pull --rebase --stat origin master

# Install or upgrade Oh My ZSH
if [[ -f ${HOME}/.oh-my-zsh/tools/upgrade.sh ]]; then
    ZSH=${HOME}/.oh-my-zsh
    env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
else
    tools/oh-my-zsh/install.sh
fi

# Install or upgrade powerline-status
#sudo pip3 install --upgrade powerline-status
get_os_info

if [ ${OS} == "arch" ]; then
    #PKGMGR=/usr/bin/pacman
    sudo /usr/bin/pacman -S --needed powerline
elif [ ${OS} == "debian" || $OS == "ubuntu"]; then
    #PKGMGR=/usr/bin/apt
    sudo /usr/bin/apt install powerline
elif [ ${OS} == "fedora" ]; then
    #PKGMGR=/usr/bin/dnf
    sudo /usr/bin/dnf install powerline
#elif [ ${OS} == "centos" ]; then
    #PKGMGR=/usr/bin/yum
#    sudo /usr/bin/yum 
fi


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
