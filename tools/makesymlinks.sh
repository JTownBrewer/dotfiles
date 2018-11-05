#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
#files="bashrc vimrc screenrc dircolors toprc tmux.conf zshrc"     # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Backup folder [$olddir]: ... "
if [[ ! -d $olddir ]]; then
	mkdir -p $olddir 2>&1 > /dev/null
	echo "Created"
else
	echo "Exists"
fi

# change to the dotfiles directory
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $dir/config/*; do
	echo -ne ".$(basename ${file}): \t"
	
	# Backup files, remove links
	if [[ -f "${HOME}/.$(basename ${file})" ]]; then
		if [[ ! -h "${HOME}/.$(basename ${file})" ]]; then
			mv ${HOME}/.$(basename ${file}) ${olddir}
			echo -ne "[Moved]\t"
		elif [[ -h "${HOME}/.$(basename ${file})" ]]; then
			rm ${HOME}/.$(basename ${file})
			echo -ne "[Link Removed]\t"
		fi
	fi

	# Link in configs
	if [[ ! -h "${HOME}/.$file" ]]; then
		ln -s ${file} ~/.$(basename ${file} )
		echo -n "[Linked] "
	else
		echo -n "[link exists] "
	fi
	echo " Done!"
done

echo "Creating symlink for vim colors."
mkdir -p ${olddir}/.vim/colors 2>&1 > /dev/null
mkdir -p ~/.vim/colors &>/dev/null 2>&1 > /dev/null
mv ~/.vim/colors/solarized.vim ${olddir}/.vim/colors 2>&1 > /dev/null
ln -s $dir/vim/colors/solarized.vim ~/.vim/colors/solarized.vim 2>&1 > /dev/null

