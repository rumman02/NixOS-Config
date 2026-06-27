# tmux-submaps.nix
{ pkgs, config, ... }: let
	submapGenerator = import ./submap-generator.nix { inherit pkgs; };
in rec {

	window = submapGenerator {
		submap_name = "[W]indow";
		mod_key = "M";
		sub_key = "w";
		options = "n";
		parent_submap = "";
		body = [
			# { "[O]pen" = window_open; }
			{ "[R]esize" = window_resize; }
			{ "[M]ove" = window_move; }
			{ "[T]ab" = window_tab; }
			{ "[X]Close" = window_close; }
			{ "[L]ist" = { options = "n"; mod_key = ""; sub_key = "l"; command = ''choose-tree''; }; }
			{ "[I]ndex" = { options = "n"; mod_key = ""; sub_key = "i"; command = ''display-panes''; }; }
			{ "[󰘶L]ayout" = { options = "r"; mod_key = ""; sub_key = "L"; command = ''next-layout''; }; }
			{ "[S]Split vertical" = { options = "n"; mod_key = ""; sub_key = "s"; command = ''split-window -h -d -c "#{pane_current_path}"''; }; }
			{ "[󰘶S]Split horizontal" = { options = "n"; mod_key = ""; sub_key = "S"; command = ''split-window -v -d -c "#{pane_current_path}"''; }; }
		];
	};

	# window_open = submapGenerator {
	# 	submap_name = "[W]indow-[O]pen";
	# 	mod_key = "";
	# 	sub_key = "o";
	# 	options = "n";
	# 	parent_submap = "[W]indow";
	# 	body = [
	# 		{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''split-window -h -d -b -c "#{pane_current_path}"''; }; }
	# 		{ "[J]Bottom" = { options = "r"; mod_key = ""; sub_key = "j"; command = ''split-window -v -d -c "#{pane_current_path}"''; }; }
	# 		{ "[K]Top" = { options = "r"; mod_key = ""; sub_key = "k"; command = ''split-window -v -d -b -c "#{pane_current_path}"''; }; }
	# 		{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''split-window -h -d -c "#{pane_current_path}"''; }; }
	# 		{ "[F]loat" = { options = "r"; mod_key = ""; sub_key = "f"; command = ''display-popup -h 85% -w 85% -d "#{pane_current_path}"''; }; }
	# 	];
	# };

	# window_close = submapGenerator {
	# 	submap_name = "[W]indow-[X]Close";
	# 	mod_key = "";
	# 	sub_key = "x";
	# 	options = "n";
	# 	parent_submap = "[W]indow";
	# 	body = [
	# 		{ "[A]ll" = { options = "r"; mod_key = ""; sub_key = "a"; command = ''kill-pane -a''; }; }
	# 		{ "[C]urrent" = { options = "r"; mod_key = ""; sub_key = "c"; command = ''kill-pane''; }; }
	# 		{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''select-pane -L \; kill-pane''; }; }
	# 		{ "[J]Bottom" = { options = "r"; mod_key = ""; sub_key = "j"; command = ''select-pane -D \; kill-pane''; }; }
	# 		{ "[K]Top" = { options = "r"; mod_key = ""; sub_key = "k"; command = ''select-pane -U \; kill-pane''; }; }
	# 		{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''select-pane -R \; kill-pane''; }; }
	# 	];
	# };
	window_close = submapGenerator {
		submap_name = "[W]indow-[X]Close";
		mod_key = "";
		sub_key = "x";
		options = "n";
		parent_submap = "[W]indow";
		body = [
			{ "[A]ll" = { options = "n"; mod_key = ""; sub_key = "a"; command = ''kill-pane -a \; kill-pane''; }; }
			{ "[C]urrent" = { options = "r"; mod_key = ""; sub_key = "c"; command = ''kill-pane''; }; }
			{ "[O]thers" = { options = "n"; mod_key = ""; sub_key = "o"; command = ''kill-pane -a''; }; }
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''select-pane -L \; kill-pane''; }; }
			{ "[J]Bottom" = { options = "r"; mod_key = ""; sub_key = "j"; command = ''select-pane -D \; kill-pane''; }; }
			{ "[K]Top" = { options = "r"; mod_key = ""; sub_key = "k"; command = ''select-pane -U \; kill-pane''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''select-pane -R \; kill-pane''; }; }
		];
	};

	window_resize = submapGenerator {
		submap_name = "[W]indow-[R]esize";
		mod_key = "";
		sub_key = "r";
		options = "n";
		parent_submap = "[W]indow";
		body = [
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''resize-pane -L 5''; }; }
			{ "[J]Bottom" = { options = "r"; mod_key = ""; sub_key = "j"; command = ''resize-pane -D 5''; }; }
			{ "[K]Top" = { options = "r"; mod_key = ""; sub_key = "k"; command = ''resize-pane -U 5''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''resize-pane -R 5''; }; }
			{ "[M]aximize" = { options = "r"; mod_key = ""; sub_key = "m"; command = ''resize-pane -Z''; }; }
		];
	};

	window_move = submapGenerator {
		submap_name = "[W]indow-[M]ove";
		mod_key = "";
		sub_key = "m";
		options = "n";
		parent_submap = "[W]indow";
		body = [
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''swap-pane -s "{left-of}"''; }; }
			{ "[J]Bottom" = { options = "r"; mod_key = ""; sub_key = "j"; command = ''swap-pane -s "{down-of}"''; }; }
			{ "[K]Top" = { options = "r"; mod_key = ""; sub_key = "k"; command = ''swap-pane -s "{up-of}"''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''swap-pane -s "{right-of}"''; }; }
			{ "[R]otate" = { options = "r"; mod_key = ""; sub_key = "c"; command = ''rotate-window''; }; }
		];
	};

	window_tab = submapGenerator {
		submap_name = "[W]indow-[T]ab";
		mod_key = "";
		sub_key = "t";
		options = "n";
		parent_submap = "[W]indow";
		body = [
			{ "[󰘶H]Left" = { options = "r"; mod_key = ""; sub_key = "H"; command = ''move-pane -t:-1 -h -d''; }; }
			{ "[󰘶L]Right" = { options = "r"; mod_key = ""; sub_key = "L"; command = ''move-pane -t:+1 -h -d''; }; }
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''break-pane -b -d''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''break-pane -a -d''; }; }
			{ "[I]ndex" = { options = "n"; mod_key = ""; sub_key = "i"; command = ''command-prompt -p "Move to window:" "move-pane -t '%%' -h -d"''; }; }
		];
	};

	tab = submapGenerator {
		submap_name = "[T]ab";
		mod_key = "M";
		sub_key = "t";
		options = "n";
		parent_submap = "";
		body = [
			# { "[O]pen" = tab_open; }
			{ "[X]Close" = tab_close; }
			{ "[S]wap" = tab_swap; }
			{ "[L]ist" = { options = "n"; mod_key = ""; sub_key = "l"; command = ''choose-tree -w''; }; }
			{ "[R]ename" = { options = "n"; mod_key = ""; sub_key = "r"; command = ''command-prompt -p "Window rename: " "rename-window '%%'"''; }; }
			{ "[N]ew" = { options = "n"; mod_key = ""; sub_key = "n"; command = ''new-window''; }; }
		];
	};

	# tab_open = submapGenerator {
	# 	submap_name = "[T]ab-[O]pen";
	# 	mod_key = "";
	# 	sub_key = "o";
	# 	options = "n";
	# 	parent_submap = "[T]ab";
	# 	body = [
	# 		{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''new-window -b -d''; }; }
	# 		{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''new-window -a -d''; }; }
	# 		{ "[N]ame" = tab_open_name; }
	# 	];
	# };

	# tab_open_name = submapGenerator {
	# 	submap_name = "[T]ab-[O]pen-[N]ame";
	# 	mod_key = "";
	# 	sub_key = "n";
	# 	options = "n";
	# 	parent_submap = "[T]ab-[O]pen";
	# 	body = [
	# 		{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''command-prompt -p "Window name: " "new-window -b; rename-window '%%'; next-window"''; }; }
	# 		{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''command-prompt -p "Window name: " "new-window -a; rename-window '%%'; next-window"''; }; }
	# 	];
	# };

	tab_close = submapGenerator {
		submap_name = "[T]ab-[X]Close";
		mod_key = "";
		sub_key = "x";
		options = "n";
		parent_submap = "[T]ab";
		body = [
			{ "[A]ll" = { options = "n"; mod_key = ""; sub_key = "l"; command = ''kill-window -a \; kill-window''; }; }
			{ "[O]thers" = { options = "n"; mod_key = ""; sub_key = "l"; command = ''kill-window -a''; }; }
			{ "[C]urrent" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''kill-window''; }; }
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''previous-window \; kill-window''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''next-window \; kill-window''; }; }
		];
	};

	tab_swap = submapGenerator {
		submap_name = "[T]ab-[S]wap";
		mod_key = "";
		sub_key = "s";
		options = "n";
		parent_submap = "[T]ab";
		body = [
			{ "[H]Left" = { options = "r"; mod_key = ""; sub_key = "h"; command = ''swap-window -d -t:-1''; }; }
			{ "[L]Right" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''swap-window -d -t:+1''; }; }
		];
	};

	session = submapGenerator {
		submap_name = "[S]ession";
		mod_key = "M";
		sub_key = "s";
		options = "n";
		parent_submap = "";
		body = [
			{ "[O]pen" = { options = "r"; mod_key = ""; sub_key = "o"; command = ''new-session''; }; }
			{ "[N]ame" = { options = "r"; mod_key = ""; sub_key = "n"; command = ''command-prompt -p "Session name: " "new-session; rename-session '%%'"''; }; }
			{ "[L]ist" = { options = "r"; mod_key = ""; sub_key = "l"; command = ''choose-tree -s''; }; }
			{ "[R]ename" = { options = "r"; mod_key = ""; sub_key = "r"; command = ''command-prompt -p "Session rename: " "rename-session '%%'"''; }; }
			{ "[X]Close" = window_close; }
		];
	};

	session_close= submapGenerator {
		submap_name = "[S]ession-[X]Close";
		mod_key = "";
		sub_key = "x";
		options = "n";
		parent_submap = "[S]ession";
		body = [
			{ "[A]ll" = { options = "n"; mod_key = ""; sub_key = "a"; command = ''kill-server''; }; }
			{ "[C]rrent" = { options = "n"; mod_key = ""; sub_key = "c"; command = ''kill-session''; }; }
			{ "[O]Others" = { options = "n"; mod_key = ""; sub_key = "o"; command = ''kill-session -a''; }; }
		];
	};

	client = submapGenerator {
		submap_name = "[C]lient";
		mod_key = "";
		sub_key = "c";
		options = "n";
		parent_submap = "[M-Space]Prefix";
		body = [
			{ "[L]ist" = { options = "n"; mod_key = ""; sub_key = "l"; command = ''choose-client''; }; }
		];
	};

	yank_mode = submapGenerator {
		submap_name = "[Y]ank";
		mod_key = "";
		sub_key = "y";
		options = "n";
		parent_submap = "[M-Space]Prefix";
		entry_command = "copy-mode";
		target_table = "copy-mode-vi"; # Default for all bindings
		body = [
			{ "[M-Esc]Cancel" = { options = "n"; mod_key = "M"; sub_key = "Escape"; command = ''send-keys -X cancel''; }; }
			{ "[V]isual" = { options = "n"; mod_key = ""; sub_key = "v"; command = ''send-keys -X begin-selection''; }; }
			{ "[C-V]Block" = { options = "n"; mod_key = "C"; sub_key = "v"; command = ''send-keys -X rectangle-toggle''; }; }
			{ "[Y]ank" = { options = "n"; mod_key = ""; sub_key = "y"; command = ''send-keys -X copy-selection''; }; }
			# seperately target_table also can be possible like this
			# { "[M-Y]Cancel" = { options = "n"; mod_key = "M"; sub_key = "y"; target_table = "copy-mode-vi"; command = ''send-keys -X cancel''; }; }
		];
	};

	prefix = submapGenerator {
		submap_name = "[M-Space]Prefix";
		mod_key = "M";
		sub_key = "space";
		options = "n";
		parent_submap = "";
		body = [
			{ "[C]lient" = client; }
			{ "[H]Toggle" = { options = "n"; mod_key = ""; sub_key = "h"; command = ''set-option status''; }; }
			{ "[D]etach" = { options = "n"; mod_key = ""; sub_key = "d"; command = ''detach-client''; }; }
			{ "[:]Command" = { options = "n"; mod_key = ""; sub_key = ":"; command = ''command-prompt''; }; }
			{ "[R]esourced" = { options = "n"; mod_key = ""; sub_key = "r"; command = ''source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config file sourced" ''; }; }
			{ "[Z]Suspend" = { options = "n"; mod_key = ""; sub_key = "z"; command = ''suspend-client''; }; }
			{ "[S]ync" = { options = "n"; mod_key = ""; sub_key = "s"; command = ''setw synchronize-panes \; display-message "Synchronize panes #{?pane_synchronized,on,off}"''; }; }
			{ "[󰘶S]ave session" = { options = "n"; mod_key = "S"; sub_key = "s"; command = ''send-keys S-s''; }; }
			{ "[󰘶R]estore session" = { options = "n"; mod_key = "S"; sub_key = "r"; command = ''send-keys S-r''; }; }
			{ "[Y]ank Mode" = yank_mode; }
		];
	};
}

