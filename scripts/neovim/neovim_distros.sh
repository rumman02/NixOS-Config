#!/usr/bin/env bash

neovim_directory="$HOME/.config/neovim_distros"
setup_neovim_config() {
	local repo_url=$1
	local config_dir=$2
	local alias_name=$3
	# Clone repo if it doesn't exist
	[ ! -d "$neovim_directory/$config_dir" ] && git clone "$repo_url" "$neovim_directory/$config_dir"
	# Create an alias function to launch Neovim with the specified config
	alias $alias_name="function ''${alias_name}_func() {
		if [ \"\$1\" = \"--config\" ]; then
			XDG_CONFIG_HOME=''${neovim_directory} NVIM_APPNAME=''${config_dir} nvim ''${neovim_directory}/''${config_dir}/init.lua
		else
			XDG_CONFIG_HOME=''${neovim_directory} NVIM_APPNAME=''${config_dir} nvim \"\$@\"
		fi
	}; ''${alias_name}_func"
}
# --- Define Neovim Distros ---
setup_neovim_config "https://github.com/nvim-lua/kickstart.nvim" "kickstart" "knvim"
setup_neovim_config "https://github.com/LazyVim/starter" "lazyvim" "lnvim"
setup_neovim_config "https://github.com/NvChad/starter" "nvchad" "nnvim"

