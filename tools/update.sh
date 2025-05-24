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
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

cd ${HOME}/dotfiles

# Update ourselves
# Fetch the latest from remote.
# If there's an update to this script, then
# re-excute

MODS=$(git ls-files -m)
if [[ -n ${MODS} ]]; then
    echo "***** *****"
    echo "Halting! There are locally modifed files in dotfiles:"
    echo ""
    echo ${MODS}
    echo "***** *****"
    exit 1
fi

git fetch --all
git diff --quiet tools/update.sh
UPDT=$?

PULL=$(git pull)
if [[ $? -ne 0 ]]; then
    echo "***** *****"
    echo "Detected error during git pull:"
    echo ""
    echo ${PULL}
    echo "***** *****"
    exit 1
fi

if [[ ${UPDT} -ne 0 ]]; then
    echo "***** *****"
    echo "Re-Executing ..."
    echo "***** *****"
    exec "$0" "$@"
fi

# Install or upgrade Oh My ZSH
if [[ -f ${HOME}/.oh-my-zsh/tools/upgrade.sh ]]; then
    ${HOME}/.oh-my-zsh/tools/upgrade.sh
else
    tools/oh-my-zsh/install.sh
fi

# Install or upgrade powerline-status
get_os_info

if [ ${OS} == "arch" ]; then
    #PKGMGR=/usr/bin/pacman
    sudo /usr/bin/pacman -S --needed powerline
elif [[ ${OS} == "debian" || $OS == "ubuntu" ]]; then
    #PKGMGR=/usr/bin/apt
    sudo /usr/bin/apt install powerline python3-powerline
elif [ ${OS} == "fedora" ]; then
    #PKGMGR=/usr/bin/dnf
    sudo /usr/bin/dnf install powerline python3-powerline tmux-powerline
#elif [ ${OS} == "centos" ]; then
    #PKGMGR=/usr/bin/yum
#    sudo /usr/bin/yum 
fi


# Install or upgrade PowerLevel10K
if [[ -d ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    pushd ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
    git pull
    popd
elif [[ -d ${HOME}/.oh-my-zsh ]]; then
    git clone https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
fi

# take care of the configuration symlinks
${HOME}/dotfiles/tools/makesymlinks.sh
case "zsh" in ("*${SHELL}")
    source ${HOME}/.zshrc
esac
