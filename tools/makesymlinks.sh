#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=$(realpath $(dirname ${BASH_SOURCE[0]})/../)
backupdir=$dir/backup

########## create backup
echo -n "Backup folder [$backupdir]: ... "
if [[ ! -d $backupdir ]]; then
	mkdir -p $backupdir 2>&1 > /dev/null
	echo "Created"
else
	echo "Exists"
fi

# change to the dotfiles directory
# cd $dir
dest_dir=${HOME}
cd ${dest_dir}

create_links() {
	folder=$1
	# echo "*****"
	# echo "Config Folder: ${folder}"
	# echo "Current Directory: $(pwd)"
	# echo "Directory Stack: [$(dirs)]"
	# echo "*****"

	for entry in ${folder}/*; do
		file="$(basename ${entry})"
		echo -ne "${file}: \t"
		if [[ ${#file} -lt 6 ]]; then
			echo -ne "\t"
		fi

		# Backup entries, remove links
		if [[ -f ".${file}" ]]; then
			if [[ ! -h ".${file}" ]]; then
				mv .${file} ${backupdir}
				echo -ne "[Moved]\t"
			fi
		# elif [[ -d ".${file}" ]]; then
		# 	# leave directories alone
		# 	echo "directory"
		elif [[ -h ".${file}" && ! -d ".${file}" ]]; then
			# Here are orphaned symlinks
			rm .${file}
			echo -ne "[Orphaned Link Removed]\t"
		fi

		# Directories
		# if [[ -d "${entry}" ]]; then
		# 	echo " >>> .${file} <<< "
		# 	if [[ ! -d ".${file}" ]]; then
		# 		# echo "creating directory: ${dest_dir}/.${file}"
		# 		mkdir ".${file}" 2>1& /dev/null;
		# 		echo "[Directory Created] "
		# 	else
		# 		echo "[Directory Exists] "
		# 	fi
		# 	pushd "$(basename ${entry})"
		# 	create_links $entry
		# 	popd
		# else
			# Link in configs
			if [[ ! -h ".${file}" ]]; then
				ln -s ${entry} .${file}
				echo -n "[Linked] "
			else
				echo -n "[link exists] "
			fi
		# fi
		echo " Done!"
	done
}

create_links ${dir}/config/
# move any existing dotfiles in homedir to backupdir, then create symlinks 
# level="${HOME}"
# for folder in $(find $dir/config/ -maxdepth 1 -type d); do
	# echo "*** create_links ${folder} ***"
	# create_links $folder
	# level="${level}/${folder}"
#	if [[ "${folder}" -ne "${dir}/config/" ]]; then
#		mkdir -p $folder 2>&1 /dev/null
#	fi
#	for subfolder in ${folder}/*/; do
#	done
# done

# 1:
# For directory in config/
#	link files
#	create subdirectory
#	change to subdirectory
#	goto 1
# 2:
# Next


#echo "Creating symlink for vim colors."
#mkdir -p ${backupdir}/vim/colors 2>&1 > /dev/null
#mkdir -p ~/.vim/colors &>/dev/null 2>&1 > /dev/null
#mv ~/.vim/colors/solarized.vim ${backupdir}/.vim/colors 2>&1 > /dev/null
#ln -s $dir/vim/colors/solarized.vim ~/.vim/colors/solarized.vim 2>&1 > /dev/null

