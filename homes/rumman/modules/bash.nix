{ pkgs, username, configdir, hostname, lib, ... }: {

	# ===========================================================================
	# BASH CONFIGURATION
	# ===========================================================================
	programs.bash = {
		enable = true;

		# ===========================================================================
		# HISTORY
		# ===========================================================================
		historySize = 10000;
		historyFileSize = 10000;
		historyControl = [ "erasedups" "ignoredups" "ignorespace" ];

		# ===========================================================================
		# SHELL OPTIONS
		# ===========================================================================
		shellOptions = [
			"histappend"      # Append to the history file, don't overwrite it
			"checkwinsize"    # Check window size after each command
			"extglob"         # Enable extended globbing
			"globstar"        # Enable ** globbing
			"checkjobs"       # Report status of running jobs before exiting
			"cdspell"         # Correct minor spelling errors in `cd` commands
			"dirspell"        # Correct minor spelling errors in directory names during completion
		];

		# ===========================================================================
		# ALIASES
		# ===========================================================================
		shellAliases = {
			# NixOS and Home Manager
			hm = "home-manager switch --flake ${configdir}#${username}";
			nr = "sudo nixos-rebuild switch --flake ${configdir}#${hostname}";

			# Common utilities
			ll = "ls -alF";
			la = "ls -A";
			l = "ls -CF";
			".." = "cd ..";
			"..." = "cd ../..";
			mkdir = "mkdir -pv";
			grep = "grep --color=auto";

			# Git shortcuts
			gs = "git status";
			ga = "git add";
			gc = "git commit";
			gp = "git push";
			gl = "git log --oneline";
		};

		# ===========================================================================
		# SESSION VARIABLES
		# ===========================================================================
		sessionVariables = {
			EDITOR = "nvim";
			HISTTIMEFORMAT = "%F %T ";
			HISTCONTROL = "ignoreboth:erasedups";
			HISTIGNORE = "ls:ll:la:cd:pwd:exit:date:* --help:rm *:pkill *:systemctl *:reboot:shutdown *";
		};

		# ===========================================================================
		# BASHRC AND PROFILE CONFIGURATION
		# ===========================================================================
		profileExtra = lib.mkOrder 500 ''
			# Add ~/.local/bin to the PATH
			export PATH="$HOME/.local/bin:$PATH"
		'';

		bashrcExtra = lib.mkOrder 1000 ''
			# ---------------------------------------------------------------------------
			# PROMPT
			# ---------------------------------------------------------------------------
			parse_git_branch() {
				git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
			}
			export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

			# ---------------------------------------------------------------------------
			# KEYBINDINGS
			# ---------------------------------------------------------------------------
			set -o vi  # Enable vi mode

			# Custom key bindings in vi mode
			bind -m vi-command 'Control-l: clear-screen'
			bind -m vi-insert 'Control-l: clear-screen'
			bind -m vi-insert 'Control-a: beginning-of-line'
			bind -m vi-insert 'Control-e: end-of-line'

			# History search bindings
			bind '"\C-k": history-search-backward'
			bind '"\C-j": history-search-forward'

			# ---------------------------------------------------------------------------
			# LESS CONFIGURATION
			# ---------------------------------------------------------------------------
			export LESS='-R -i -w -M -z-4'
			export LESS_TERMCAP_mb=$ '\e[1;32m'
			export LESS_TERMCAP_md=$ '\e[1;32m'
			export LESS_TERMCAP_me=$ '\e[0m'
			export LESS_TERMCAP_se=$ '\e[0m'
			export LESS_TERMCAP_so=$ '\e[01;33m'
			export LESS_TERMCAP_ue=$ '\e[0m'
			export LESS_TERMCAP_us=$ '\e[1;4;31m'

			# ---------------------------------------------------------------------------
			# CUSTOM FUNCTIONS
			# ---------------------------------------------------------------------------
			mkcd() {
				mkdir -p "$1" && cd "$1"
			}

			extract() {
				if [ -f "$1" ]; then
					case $1 in
						*.tar.bz2)   tar xjf "$1"     ;;
						*.tar.gz)    tar xzf "$1"     ;;
						*.bz2)       bunzip2 "$1"     ;;
						*.rar)       unrar e "$1"     ;;
						*.gz)        gunzip "$1"      ;;
						*.tar)       tar xf "$1"      ;;
						*.tbz2)      tar xjf "$1"     ;;
						*.tgz)       tar xzf "$1"     ;;
						*.zip)       unzip "$1"       ;;
						*.Z)         uncompress "$1"  ;;
						*.7z)        7z x "$1"        ;;
						*)           echo "'$1' cannot be extracted via extract()" ;;
					esac
				else
					echo "'$1' is not a valid file"
				fi
			}

			up() {
				local d=""
				local limit="$1"

				if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
					limit=1
				fi

				for ((i=1; i<=limit; i++)); do
					d="../$d"
				done

				d=$(echo "$d" | sed 's|/$||')

				if [ -z "$d" ]; then
					d=".."
				fi

				cd "$d" || return
			}

			# ---------------------------------------------------------------------------
			# FZF INTEGRATION
			# ---------------------------------------------------------------------------
			if command -v fzf >/dev/null 2>&1; then
				bind -x '"\C-t": fzf-file-widget'
				bind -x '"\C-r": fzf-history-widget'
				bind -x '"\C-o": fzf-cd-widget'

				fzf-file-widget() {
					local selected
					selected=$(find . -type f 2>/dev/null | fzf) && READLINE_LINE="$selected" && READLINE_POINT=''${#READLINE_LINE}
				}

				fzf-history-widget() {
					local selected
					selected=$(history | fzf --tac | sed 's/^ *[0-9]* *//')
					READLINE_LINE="$selected"
					READLINE_POINT=''${#READLINE_LINE}
				}

				fzf-cd-widget() {
					local dir
					dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
				}
			fi

			# ---------------------------------------------------------------------------
			# NIX SHELL INTEGRATION
			# ---------------------------------------------------------------------------
			if [ -n "$IN_NIX_SHELL" ]; then
				export PS1="(nix-shell) $PS1"
			fi

			# ---------------------------------------------------------------------------
			# COMPLETION
			# ---------------------------------------------------------------------------
			if ! shopt -oq posix; then
				if [ -f /usr/share/bash-completion/bash_completion ]; then
					. /usr/share/bash-completion/bash_completion
				elif [ -f /etc/bash_completion ]; then
					. /etc/bash_completion
				fi
			fi

			if [ -f "${pkgs.git}/share/bash-completion/completions/git" ]; then
				source "${pkgs.git}/share/bash-completion/completions/git"
			fi

			# ---------------------------------------------------------------------------
			# CUSTOM NEOVIM DISTROS SETUP
			# ---------------------------------------------------------------------------
			# neovim_directory="$HOME/.config/neovim_distros"
			# setup_neovim_config() {
			#   local repo_url=$1
			#   local config_dir=$2
			#   local alias_name=$3
			#
			#   # Clone repo if it doesn't exist
			#   [ ! -d "$neovim_directory/$config_dir" ] && git clone "$repo_url" "$neovim_directory/$config_dir"
			#
			#   # Create an alias function to launch Neovim with the specified config
			#   alias $alias_name="function ''${alias_name}_func() {
			#     if [ \"$1\" = \"--config\" ]; then
			#       XDG_CONFIG_HOME=''${neovim_directory} NVIM_APPNAME=''${config_dir} nvim ''${neovim_directory}/''${config_dir}/init.lua
			#     else
			#       XDG_CONFIG_HOME=''${neovim_directory} NVIM_APPNAME=''${config_dir} nvim \"$@\"
			#     fi
			#   }; ''${alias_name}_func"
			# }
			#
			# # Define Neovim Distros
			# setup_neovim_config "https://github.com/nvim-lua/kickstart.nvim" "kickstart" "knvim"
			# setup_neovim_config "https://github.com/LazyVim/starter" "lazyvim" "lnvim"
			# setup_neovim_config "https://github.com/NvChad/starter" "nvchad" "nnvim"
		'';
	};
}

