{ pkgs, config, ... }: let
	keymaps = import ./keymaps { inherit pkgs config; };
	sharedConfig = import ../../../../config.nix;
	color = config.lib.stylix.colors;
in
{
	programs.tmux = {
		enable = true;
		baseIndex = 1;
		package = pkgs.tmux.overrideAttrs (old: {
			version = "3.4";
			src = pkgs.fetchFromGitHub {
				owner = "tmux";
				repo = "tmux";
				rev = "3.4";  # Git tag
				sha256 = "sha256-RX3RZ0Mcyda7C7im1r4QgUxTnp95nfpGgQ2HRxr0s64=";
			};
		});
		clock24 = true;
		keyMode = "vi";
		mouse = true;
		historyLimit = sharedConfig.historySize;
		escapeTime = 0;
		newSession = false;
		prefix = "M-|";
		terminal = "\${TERM}";
		plugins = with pkgs.tmuxPlugins; [
			{
				plugin = resurrect;
				extraConfig = ''
					set -g @resurrect-strategy-nvim "session"
					set -g @resurrect-save "S"                    # save session with prefix + S
					set -g @resurrect-restore "R"                 # restore session with prefix + R
				'';
			}
			{
				plugin = continuum;
				extraConfig = ''
				  set -g @continuum-restore 'off'
				  set -g @continuum-save-interval '60' # minutes
				'';
			}
			# {
			# 	plugin = tokyo-night-tmux;
			# 	extraConfig = ''
			# 		set -g @tokyo-night-tmux_theme night
			# 		set -g @tokyo-night-tmux_terminal_icon 󱓼
			# 		set -g @tokyo-night-tmux_active_terminal_icon 󱓻
			# 		set -g @tokyo-night-tmux_window_id_style fsquare
			# 		set -g @tokyo-night-tmux_pane_id_style dsquare
			# 		set -g @tokyo-night-tmux_zoom_id_style fsquare
			# 		set -g @tokyo-night-tmux_numbers true
			# 	'';
			# }
		];

		extraConfig = ''

	  # ========================================
      # TERMINAL COMPATIBILITY & COLOR SUPPORT
      # ========================================
      set -as terminal-features ",xterm-256color:RGB"
      set -sg terminal-overrides ",*:RGB"
      set -sg terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -sg terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set -as terminal-overrides ',*:sitm=\E[3m'     # italics support
      set -as terminal-overrides ',*:ritm=\E[23m'    # disable italics
      set -as terminal-overrides ',*:smxx=\E[9m'     # strikethrough support

      # ========================================
      # KEY HANDLING & INTEGRATION
      # ========================================
      set -s extended-keys always          # enables extended-keys (ex: <M-S-C-CR>)
      set -g xterm-keys on                  # enable xterm-style function key sequences
      set -as terminal-features ',*:extkeys' # enable extended key reporting
      set -s focus-events on                # enable focus events for better editor integration
      set -gq allow-passthrough on          # nvim plugin config - folke/zen-mode

      # ========================================
      # TMUX BEHAVIOR SETTINGS
      # ========================================
      set -g base-index 1                   # window starting index
      set -g pane-base-index 1              # pane starting index
      set -g history-limit 1000000          # maximum number of lines held in window history
      set -s escape-time 0                  # reduce delay after pressing tmux prefix
      set -g repeat-time 2000               # allow press multiple commands without prefix
      set -g renumber-windows on            # renumber windows to maintain order
      set -g mouse on                       # enable mouse access
      set -g display-time 5000              # display tmux messages in milliseconds
      set -g display-panes-time 5000        # show pane numbers for 5 seconds
      set -g mode-keys vi                   # enable vi-style copy mode
      set -g detach-on-destroy next         # attach to next session if current is killed
      set -g aggressive-resize on           # resize window to smallest client viewing it

      # ========================================
      # VISUAL & NOTIFICATION SETTINGS
      # ========================================
      set -g visual-activity off           # disable visual notification for activity
      set -g visual-bell off               # disable visual bell
      set -g bell-action none              # disable bell
      set -g monitor-activity on
      set -g activity-action none

      # ========================================
      # PREFIX & CLIPBOARD
      # ========================================
      set -g prefix M-|                     # set prefix key
      set -g set-clipboard on               # enable clipboard integration
      set -g copy-command 'pbcopy'          # macOS clipboard (change to 'xclip -sel c' for Linux)

      # Clear all existing key bindings
      unbind-key -a

      # ${keymaps}

      # ========================================
      # CATPPUCCIN MOCHA COLOR PALETTE
      # ========================================
	  thm_bg="#${color.base00}"
	  thm_fg="#${color.base05}"
	  thm_cyan="#${color.base0C}"
	  thm_black="#${color.base00}"
	  thm_gray="#${color.base02}"
	  thm_magenta="#${color.base0E}"
	  thm_pink="#${color.base06}"
	  thm_red="#${color.base08}"
	  thm_green="#${color.base0B}"
	  thm_yellow="#${color.base0A}"
	  thm_blue="#${color.base0D}"
	  thm_orange="#${color.base09}"
	  thm_black4="#${color.base03}"

      # ========================================
      # STATUS BAR CONFIGURATION
      # ========================================
      set -g status-position bottom
      set -g status-justify left
      set -g status-style "bg=$thm_bg,fg=$thm_fg"
      set -g status-left-length 100
      set -g status-right-length 150
      set -g status-interval 1              # update status-line every second

      # Left side of status bar
      set -g status-left "#[bg=$thm_green,fg=$thm_black,bold] #S #[bg=$thm_bg,fg=$thm_green,nobold]"

      # Right side of status bar
      set -g status-right "#[bg=$thm_bg,fg=$thm_gray]#[bg=$thm_gray,fg=$thm_fg] %Y-%m-%d #[bg=$thm_gray,fg=$thm_blue]#[bg=$thm_blue,fg=$thm_black,bold] %H:%M "

      # ========================================
      # WINDOW STATUS STYLING
      # ========================================
      set -g automatic-rename on            # automatic window name based on workflow
      set -g automatic-rename-format "#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}"

      # Current window
      # set -g window-status-current-style "bg=$thm_magenta,fg=$thm_black,bold"
      set -g window-status-current-format "#[bg=$thm_bg,fg=$thm_magenta]#[bg=$thm_magenta,fg=$thm_black,bold] #I #W #[bg=$thm_bg,fg=$thm_magenta,nobold]"

      # Inactive windows
      # set -g window-status-style "bg=$thm_gray,fg=$thm_fg"
      set -g window-status-style "bg=$thm_bg,fg=$thm_bg"
      # set -g window-status-format "#[bg=$thm_bg,fg=$thm_gray]#[bg=$thm_gray,fg=$thm_fg] #I #W #[bg=$thm_bg,fg=$thm_gray]"
      set -g window-status-format "#[bg=$thm_bg,fg=$thm_fg]  #I #W  "

      # Window activity & bell styling
      set -g window-status-bell-style "bg=$thm_red,fg=$thm_black,bold"
      set -g window-status-activity-style "bg=$thm_yellow,fg=$thm_black"

      # ========================================
      # PANE & UI STYLING
      # ========================================
      set -g pane-border-style "fg=$thm_gray"
      set -g pane-active-border-style "fg=$thm_magenta"

      # Message styling
      set -g message-style "bg=$thm_orange,fg=$thm_black"
      set -g message-command-style "bg=$thm_orange,fg=$thm_black"

      # Copy mode highlighting
      set -g mode-style "bg=$thm_pink,fg=$thm_black"

      # Clock mode
      set -g clock-mode-colour "$thm_blue"

      # ========================================
      # PREFIX HIGHLIGHT PLUGIN CONFIG
      # ========================================
      set -g @prefix_highlight_fg "$thm_black"
      set -g @prefix_highlight_bg "$thm_cyan"
      set -g @prefix_highlight_prefix_prompt " PREFIX "
      set -g @prefix_highlight_copy_prompt " COPY "
		'';
	};
}

