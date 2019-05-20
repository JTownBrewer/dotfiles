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

dest_dir=${HOME}
pushd ${HOME} > /dev/null

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
		elif [[ -h ".${file}" && ! -d ".${file}" ]]; then
			# Here are orphaned symlinks
			rm .${file}
			echo -ne "[Orphaned Link Removed]\t"
		fi

		# Directories
		if [[ -d "${entry}" ]]; then
			if [[ ! -d ".${file}" ]]; then
				# echo "creating directory: ${dest_dir}/.${file}"
				mkdir ".${file}"
				echo "[Directory Created] "
			else
				echo "[Directory Exists] "
			fi
			pushd ${entry} > /dev/null
			for dfile in $(find ./ -type f); do
				echo -n "  $(basename ${dfile}): \t [Linked]"
				mkdir -p ${dest_dir}/.${file}/$(dirname ${dfile}) &> /dev/null
				ln -s $(realpath ${dfile}) ${dest_dir}/.${file}/${dfile} &> /dev/null
			done
			popd > /dev/null
		else
			# Link in configs
			if [[ ! -h ".${file}" ]]; then
				ln -s ${entry} .${file}
				echo -n "[Linked] "
			else
				echo -n "[link exists] "
			fi
		fi
		echo " Done!"
	done
}

create_links ${dir}/config/
popd > /dev/null

# Find powerline dependencies
pvim=$(python3 -c "import powerline as _; print(_.__path__)")
echo ${pvim}
