#!/bin/bash

IFS_ORI=$IFS
IFS=$'\n'

requirements="OK"

##########################################
#    Still working but in update work    #
# should be finished in January the 15th # 
##########################################

if [[ ! -f "/usr/bin/g++" ]];then
	gInstall="sudo apt install g++" 
	requirements_status="/!\\ \033[1mg++ missing\033[0m (run $gInstall)"
	requirements="KO"
else
	requirements_status="g++ OK"
fi

if [[ ! -f "/usr/bin/rg" ]];then
	rgInstall="wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb -P ./packages/ && sudo apt install ./packages/ripgrep_13.0.0_amd64.deb -y"
	requirements_status="$requirements_status\n/!\\ \033[1mripgrep missing\033[0m (https://github.com/BurntSushi/ripgrep/releases)"
	requirements="KO"
else
	requirements_status="ripgrep OK"
fi

if [[ $(nvim -v 2>&1 | grep "NVIM v" | cut -d'.' -f 2) -lt 8 || ! -f "/usr/bin/nvim" ]];then
	nvInstall="sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt update && sudo apt install neovim"
	requirements_status="$requirements_status\n/!\\ \033[1mNeoVim\033[0m wrong version or missing (https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)"
	requirements="KO"
else
	requirements_status="$requirements_status\nNeoVim OK"
fi

if [[ $(node -v 2>&1 | cut -d'.' -f1 | tail -c 3) -lt 16 || ! -f "/usr/bin/node" || -f "/usr/bin/npm" ]];then
	if [[ $(cat /etc/issue | cut -d' ' -f2 | cut -d -f1) -lt 18 ]];then
		nodeInstall="curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt install nodejs -y"
		requirements_status="$requirements_status\n/!\\ \033[1mNode\033[0m wrong version or missing (https://joshtronic.com/2021/05/09/how-to-install-nodejs-16-on-ubuntu-2004-lts/)"
	else
		nodeInstall="curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install nodejs -y"
		requirements_status="$requirements_status\n/!\\ \033[1mNode &/OR NPM\033[0m wrong version or missing (https://joshtronic.com/2022/04/24/how-to-install-nodejs-18-on-ubuntu-2004-lts/)"
	fi
	requirements="KO"
else
        requirements_status="$requirements_status\nNode & npm OK"
fi

if [[ $(php -v 2>&1 | head -n 1 | cut -d' ' -f2 | cut -d'.' -f1) -lt 8 || ! -f "/usr/bin/php" ]];then
	requirements_status="$requirements_status\n/!\\ \033[1mPHP\033[0m wrong version or missing https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/)"
        requirements="KO"
else
        requirements_status="$requirements_status\nPHP OK"
fi

if [[ ! -f "/usr/bin/composer" ]];then
	requirements_status="$requirements_status\n/!\\ \033[1mcomposer\033[0m wrong version or missing (https://getcomposer.org/download/)"
        requirements="KO"
else
        requirements_status="$requirements_status\ncomposer OK"
fi

echo -e $requirements_status

if [[ $requirements == "OK" ]];then
	echo -n "You are meeting the minimum requirements, Do you want to go on the the intallation ?  [(Y)/n]"
	read -r runInstallation
else
	echo -e "/!\\ You are \033[1mNOT\033[0m meeting the minimum requirements, Do you want to go on with nvim_optimizationsthe the intallation anyway?  [(Y)/n]"
	read -r runInstallation
fi

if [[ $runInstallation == "Y" || $runInstallation == "y" ]];then
	cd ~
	mkdir .config
	#mkdir -p .config/nvim/lua/core/plugin_config
	wget https://github.com/bellaichef/nvim_optimizations/archive/refs/heads/main.zip
	unzip main.zip && rm main.zip
	mv  nvim_optimizations-main/nvim .config/
	rm -r nvim_optimizations-main
	nvim
	nvim
  echo ""
  echo "---------------------------------------------------------------------------------------------------------
Done !!!!
---------------------------------------------------------------------------------------------------------"

else
	echo "You answered with n/N or any other chars than Y/y, we consider this as a N. ;-) !"
	exit
fi

IFS=$IFS_ORI
