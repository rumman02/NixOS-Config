{ pkgs, config, configdir, username, hostname, lib, ... }:

let
	# ============================================================================
	# SHARED CONFIGURATION & IMPORTS
	# ============================================================================
	sharedConfig = import ../../../config.nix;
	color = config.lib.stylix.colors;
	# neovim_distros = pkgs.writeShellScript "neovim_distros" (builtins.readFile ../../../scripts/neovim/neovim_distros.sh);

	# ============================================================================
	# ZSH-VI-MODE CURSOR CONFIGURATIONS
	# ============================================================================

	# Non-blinking block cursors for all modes
	zsh_non_blink_block_cursor = ''
	# Non-blinking block cursors
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	'';

	# Blinking block cursors for all modes
	zsh_blink_block_cursor = ''
	# blinking block cursors
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	'';

	# Non-blinking cursors with different shapes per mode
	zsh_non_blink_cursor = ''
	# Non-blinking cursors
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLOCK
	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
	'';

	# Blinking cursors with different shapes per mode
	zsh_blink_cursor = ''
	# blinking cursors
	ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
	ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
	ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
	'';

in {
	# ============================================================================
	# ZSH CONFIGURATION
	# ============================================================================
	programs.zsh = {
		enable = true;
		autocd = true; # Automatically cd into directory when typing just the path

		# ============================================================================
		# AUTO-SUGGESTIONS
		# ============================================================================
		autosuggestion = {
			enable = true;
			strategy = [
				"history"     # Suggest from command history
				"completion"  # Suggest from completion system
			];
		};

		# ============================================================================
		# HISTORY CONFIGURATION
		# ============================================================================
		historySubstringSearch.enable = true; # Enable history substring search
		# defaultKeymap = "viins"; # Using zsh-vi-mode plugin instead for more features

		completionInit = "autoload -U compinit && compinit"; # Initialize completion system
		dotDir = "${config.xdg.configHome}/zsh"; # Zsh config directory

		history = {
			ignoreDups = true;    # Don't record duplicate commands
			ignoreSpace = true;   # Don't record commands starting with space
			saveNoDups = true;    # Don't save duplicate commands
			findNoDups = true;    # Don't show duplicates when searching
			share = true;         # Share history between sessions
			save = sharedConfig.historySize;
			size = sharedConfig.historyFileSize;
			path = "${config.xdg.dataHome}/zsh/.zsh_history";

			# Commands to ignore in history
			ignorePatterns = [
				"rm *"        # Dangerous file operations
				"pkill *"     # Process killing
				"systemctl *" # System control commands
				"reboot"      # System reboot
				"shutdown *"  # System shutdown
			];
		};

		# ============================================================================
		# ZSH PLUGINS
		# ============================================================================
		plugins = with pkgs; [
			{
				name = "zsh-vi-mode";
				src = zsh-vi-mode;
				file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
			}
			{
				name = "zsh-defer";
				src = zsh-defer;
				file = "share/zsh-defer/zsh-defer.plugin.zsh";
			}
			# Alternative bd plugin (commented out - loaded via defer instead)
			# {
			#   name = "zsh-bd";
			#   src = zsh-bd;
			#   file = "share/zsh-bd/bd.zsh";
			# }
		];

		# ============================================================================
		# SHELL ALIASES
		# ============================================================================
		shellAliases = let
			# Generate dot aliases for quick directory navigation
			mkDotAlias = n: {
				name = builtins.concatStringsSep "" (builtins.genList (_: ".") n);
				value = if n == 1 then "pwd"                    # . = pwd
				else if n == 2 then "cd .."                     # .. = cd ..
				else "cd " + builtins.concatStringsSep "" (builtins.genList (_: "../") (n - 1));
			};

			# Generate dot aliases (., .., ..., ...., etc.)
			dotAliases = let
				dotrepeat = 10;
			in builtins.listToAttrs (map mkDotAlias (builtins.genList (x: x + 1) dotrepeat));

			# Static command aliases
			staticAliases = rec {
				# ========================================================================
				# LS VARIANTS
				# ========================================================================
				ls = "ls --color=auto -F";     # Colorized ls with file type indicators
				ll = "ls -lh";                 # Long format with human-readable sizes
				la = "ls -AF";                 # Show dotfiles with type indicators
				lsla = "ls -la";               # Long format with dotfiles

				# ========================================================================
				# NIX MANAGEMENT
				# ========================================================================
				hm = "home-manager switch --flake ${configdir}#${username}";  # Home Manager rebuild
				nr = "sudo nixos-rebuild switch --flake ${configdir}#${hostname}"; # NixOS rebuild
				nu = "nix flake update && ${nr} && ${hm}";  # Update flake and rebuild both
				gc = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && nix-collect-garbage && nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --optimise && sudo nixos-rebuild switch --flake ${configdir}#${hostname} &&  home-manager switch --flake ${configdir}#${username}";

				# ========================================================================
				# ENHANCED TOOLS
				# ========================================================================
				fzfp = "fzf --preview 'bat --style=numbers --color=always {}'"; # FZF with bat preview

				# Bat replacements for common tools
				cat = "bat";      # Syntax highlighted cat
				diff = "batdiff"; # Syntax highlighted diff
				man = "batman";   # Syntax highlighted man pages
				grep = "batgrep"; # Enhanced grep with bat
				watch = "batwatch"; # Enhanced watch with bat
			};

		in dotAliases // staticAliases; # Combine dot aliases and static aliases

		# ============================================================================
		# ENVIRONMENT VARIABLES
		# ============================================================================
		envExtra = ''
		  export EDITOR="nvim"
		'';

		# ============================================================================
		# ZSH INITIALIZATION
		# ============================================================================
		initContent = let
			# Early initialization (runs first)
			zshConfigEarlyInit = lib.mkOrder 500 ''
			# Early initialization code goes here
			'';

			# Main configuration (runs after plugins are loaded)
			zshConfig = lib.mkOrder 1000 ''
			# Initialize plugins and key bindings after zsh-vi-mode loads
			function zvm_after_init() {
			  # ====================================================================
			  # KEY BINDINGS
			  # ====================================================================
			  bindkey '^k' history-substring-search-up    # Ctrl+K for history up
			  bindkey '^j' history-substring-search-down  # Ctrl+J for history down
			  bindkey '^l' autosuggest-accept            # Ctrl+L to accept suggestion

			  # ====================================================================
			  # LAZY-LOADED PLUGINS (for faster startup)
			  # ====================================================================
			  zsh-defer -t 0.5 source "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh"
			  zsh-defer -t 0.6 autopair-init
			  zsh-defer -t 0.7 source "${pkgs.zsh-bd}/share/zsh-bd/bd.plugin.zsh"
			  zsh-defer -t 0.8 source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
			  zsh-defer -t 0.9 source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"

			  # ====================================================================
			  # FZF-TAB THEME (Catppuccin-inspired colors)
			  # ====================================================================
			  zstyle ':fzf-tab:*' fzf-flags --color=fg:#${color.base04},bg:#${color.base00},hl:#${color.base05} \
							--color=fg+:#${color.base06},bg+:#${color.base01},hl+:#${color.base06} \
							--color=info:#${color.base0E},prompt:#${color.base0D},pointer:#${color.base0C} \
							--color=marker:#${color.base0B},spinner:#${color.base06},header:#${color.base0C}

			  # Additional fzf-tab styling options (commented out)
			  # zstyle ':fzf-tab:*' switch-group ',' '.'
			  # zstyle ':fzf-tab:*' continuous-trigger 'tab'

			  # ====================================================================
			  # ZSH-VI-MODE CONFIGURATION
			  # ====================================================================
			  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE  # Use ZLE for better compatibility
			  ZVM_KEYTIMEOUT=0.1                          # Fast key timeout
			  ZVM_ESCAPE_KEYTIMEOUT=0.1                   # Fast escape timeout
			  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT         # Start in insert mode
			  ZVM_CURSOR_STYLE_ENABLED=true               # Enable cursor styling

			  # Apply cursor configuration (currently using non-blinking block cursors)
			  ${zsh_non_blink_block_cursor}
		}
			'';
		in
			lib.mkMerge [ zshConfigEarlyInit zshConfig ];
	};
}

# ============================================================================
# COMMENTED OUT CODE - Alternative zsh-hist plugin
# ============================================================================
# zsh-defer -t 0.4 source "${pkgs.fetchFromGitHub {
#   owner = "marlonrichert";
#   repo = "zsh-hist";
#   rev = "main";
#   hash = "sha256-6A41J5RJ2v9Zaww3714kaoYmiBu21hS3QQRVHdiafBE=";
# }}/zsh-hist.plugin.zsh"

