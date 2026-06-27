{ pkgs, config, ... }: let
	submaps = import ./submaps.nix { inherit pkgs config; };
in
''
# window switch (w-h/l/0-9)
bind-key -n M-1 select-window -t 1 # go window 1
bind-key -n M-2 select-window -t 2 # go window 2
bind-key -n M-3 select-window -t 3 # go window 3
bind-key -n M-4 select-window -t 4 # go window 4
bind-key -n M-5 select-window -t 5 # go window 5
bind-key -n M-6 select-window -t 6 # go window 6
bind-key -n M-7 select-window -t 7 # go window 7
bind-key -n M-8 select-window -t 8 # go window 8
bind-key -n M-9 select-window -t 9 # go window 9
bind-key -n M-0 select-window -t 10 # go window 10
bind-key -rT window 1 select-window -t 1 # go window 1
bind-key -rT window 2 select-window -t 2 # go window 2
bind-key -rT window 3 select-window -t 3 # go window 3
bind-key -rT window 4 select-window -t 4 # go window 4
bind-key -rT window 5 select-window -t 5 # go window 5
bind-key -rT window 6 select-window -t 6 # go window 6
bind-key -rT window 7 select-window -t 7 # go window 7
bind-key -rT window 8 select-window -t 8 # go window 8
bind-key -rT window 9 select-window -t 9 # go window 9
bind-key -rT window 0 select-window -t 10 # go window 10
bind-key -rT window i command-prompt -p "Window index:" "select-window -t '%%'"	# command prompt to go window index
bind-key -n M-H previous-window	# go window previous
bind-key -n M-L next-window	# go window next

# session switch previous & next (s-h/j/k/l)
bind-key -rT session 1 attach-session -t 1 # go window 1
bind-key -rT session 2 attach-session -t 2 # go window 2
bind-key -rT session 3 attach-session -t 3 # go window 3
bind-key -rT session 4 attach-session -t 4 # go window 4
bind-key -rT session 5 attach-session -t 5 # go window 5
bind-key -rT session 6 attach-session -t 6 # go window 6
bind-key -rT session 7 attach-session -t 7 # go window 7
bind-key -rT session 8 attach-session -t 8 # go window 8
bind-key -rT session 9 attach-session -t 9 # go window 9
bind-key -rT session i command-prompt -p "Session index:" "attach-session -t '%%'"	# command prompt to go window index
bind-key -n M-J switch-client -n
bind-key -n M-K switch-client -p

# navigate between vim/nvim & tmux pane
bind-key -n M-h "select-pane -L"
bind-key -n M-j "select-pane -D"
bind-key -n M-k "select-pane -U"
bind-key -n M-l "select-pane -R"
bind-key -n M-p "select-pane -l"

${submaps.window}
${submaps.tab}
${submaps.session}
${submaps.client}
${submaps.prefix}
''
# ${submaps.yank_mode}


