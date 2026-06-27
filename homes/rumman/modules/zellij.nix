let
	sharedConfig = import ../../../config.nix;
in {
	programs.zellij = {
		enable = true;
		settings = {
			simplified_ui = true;
			pane_frames = false;
			default_mode = "normal";
			default_shell = "zsh";
			default_layout = "default";
			mouse_mode = true;
			scroll_buffer_size = sharedConfig.scrollback;
			copy_command = "wl-copy";
			show_startup_tips = false;
			show_release_notes = false;
			ui = {
				pane_frames = {
					rounded_corners = true;
					hide_session_name = true;
				};
			};

			keybinds = {
				_props.clear-defaults = true;
				# locked._children = [
				# 	# { bind = { _args = ["Alt space"] ; SwitchToMode._args = ["normal"];};}
				# ];
				normal._children = [
					{ bind = { _args = ["alt h"]; _children = [{ MoveFocus = ["Left"];}];};}
					{ bind = { _args = ["alt j"]; _children = [{ MoveFocus = ["Down"];}];};}
					{ bind = { _args = ["alt k"]; _children = [{ MoveFocus = ["Up"]; }];};}
					{ bind = { _args = ["alt l"]; _children = [{ MoveFocus = ["Right"];}];};}
					{ bind = { _args = ["alt w"]; SwitchToMode._args = ["pane"];};}
					{ bind = { _args = ["esc"]; SwitchToMode._args = ["normal"];};}
				];
				pane._children = [
					{ bind = { _args = ["alt h"]; _children = [{ MoveFocus = ["left"];}];};}
					{ bind = { _args = ["alt j"]; _children = [{ MoveFocus = ["down"];}];};}
					{ bind = { _args = ["alt k"]; _children = [{ MoveFocus = ["up"];}];};}
					{ bind = { _args = ["alt l"]; _children = [{ MoveFocus = ["right"];}];};}
					{ bind = { _args = ["S"]; NewPane = "down";};}
					{ bind = { _args = ["s"]; NewPane = "right";};}
					{ bind = { _args = ["r"]; SwitchToMode._args = ["resize"];};}
					{ bind = { _args = ["esc"]; SwitchToMode._args = ["normal"];};}
					{ bind = { _args = ["x"]; CloseFocus = {};};}
				];
				resize._children = [
					{ bind = { _args = ["h"]; _children = [{ Resize = ["left"];}];};}
					{ bind = { _args = ["j"]; _children = [{ Resize = ["down"];}];};}
					{ bind = { _args = ["k"]; _children = [{ Resize = ["up"];}];};}
					{ bind = { _args = ["l"]; _children = [{ Resize = ["right"];}];};}
					{ bind = { _args = ["esc"]; SwitchToMode._args = ["normal"];};}
				];
			};
		};
	};
}
# {
# 	programs.zellij = {
# 		enable = true;
# 		settings = {
# 			simplified_ui = true;
# 			pane_frames = false;
# 			default_mode = "locked";
# 			default_shell = "zsh";
# 			default_layout = "default";
# 			mouse_mode = true;
# 			scroll_buffer_size = 50000;
# 			copy_command = "wl-copy";
# 			show_startup_tips = false;
# 			show_release_notes = false;
# 			ui = {
# 				pane_frames = {
# 					rounded_corners = true;
# 					hide_session_name = true;
# 				};
# 			};
# 			keybinds = {
# 				_props.clear-defaults = true;
# 				locked._children = [
# 					{ bind = { _args = ["Ctrl h"] ; _children = [ { MoveFocus = ["Left"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Ctrl j"] ; _children = [ { MoveFocus = ["Down"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Ctrl k"] ; _children = [ { MoveFocus = ["Up"]    ; } ] ; } ; }
# 					{ bind = { _args = ["Ctrl l"] ; _children = [ { MoveFocus = ["Right"] ; } ] ; } ; }
# 					{ bind = { _args = ["Alt w"] ; SwitchToMode._args = ["pane"]  ; }; }
# 					{ bind = { _args = ["Alt t"] ; SwitchToMode._args = ["tab"]  ; }; }
# 					# { bind = { _args = ["Alt s"] ; SwitchToMode._args = ["session"]  ; }; }
# 					{ bind = { _args = ["Alt Space"]; SwitchToMode._args = ["normal"]; }; }
# 				];
# 				normal._children = [
# 					{ bind = { _args = ["Alt h"]    ; _children = [ { MoveFocus = ["Left"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Alt j"]    ; _children = [ { MoveFocus = ["Down"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Alt k"]    ; _children = [ { MoveFocus = ["Up"]    ; } ] ; } ; }
# 					{ bind = { _args = ["Alt l"]    ; _children = [ { MoveFocus = ["Right"] ; } ] ; } ; }
# 					{ bind = { _args = ["w"]        ; SwitchToMode._args = ["pane"]         ; }   ; }
# 					{ bind = { _args = ["Esc"]      ; SwitchToMode._args = ["locked"]       ; }   ; }
# 					{ bind = { _args = ["Alt Space"]; SwitchToMode._args = ["locked"]       ; }   ; }
# 				];
# 				pane._children = [
# 					{ bind = { _args = ["Alt h"]    ; _children = [ { MoveFocus = ["Left"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Alt j"]    ; _children = [ { MoveFocus = ["Down"]  ; } ] ; } ; }
# 					{ bind = { _args = ["Alt k"]    ; _children = [ { MoveFocus = ["Up"]    ; } ] ; } ; }
# 					{ bind = { _args = ["Alt l"]    ; _children = [ { MoveFocus = ["Right"] ; } ] ; } ; }
# 					{ bind = { _args = ["s"]        ; NewPane = "down"                      ; }   ; }
# 					{ bind = { _args = ["S"]        ; NewPane = "right"                     ; }   ; }
# 					{ bind = { _args = ["Esc"]      ; SwitchToMode._args = ["locked"]       ; }   ; }
# 					{ bind = { _args = ["Alt Space"]; SwitchToMode._args = ["locked"]       ; }   ; }
# 				];
# 				tab._children = [
# 				];
# 				# session._children = [];
# 				# resize._children = [];
# 				# move._children = [];
# 				# scroll._children = [];
# 				# search._children = [];
# 				# entersearch._children = [];
# 				# renametab._children = [];
# 				# renamepane._children = [];
# 				# tmux._children = [];
# 			};
#
#
#
#
#
#
#
# 			# copy_on_select = false;
# 			# pane_frames = true;
# 			# auto_layout = true;
# 			# show_release_notes = false;
# 			# show_startup_tips = false;
# 			#
# 			# ui = {
# 			# 	pane_frames = {
# 			# 		rounded_corners = true;
# 			# 	};
# 			# };
# 			#
# 			# keybinds = {
# 			# 	_props.clear-defaults = true;
# 			#
# 			# 	locked._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["Ctrl Space"];
# 			# 				SwitchToMode._args = ["normal"];
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	normal._children = [
# 			# 		{ bind = { _args = ["w"]; SwitchToMode._args = ["pane"]; }; }
# 			# 		{ bind = { _args = ["t"]; SwitchToMode._args = ["tab"]; }; }
# 			# 		{ bind = { _args = ["s"]; SwitchToMode._args = ["session"]; }; }
# 			# 		{ bind = { _args = ["H"]; GoToPreviousTab = {}; }; }
# 			# 		{ bind = { _args = ["L"]; GoToNextTab = {}; }; }
# 			# 		{ bind = { _args = ["h"]; _children = [ { MoveFocus = ["Left"]; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["j"]; _children = [ { MoveFocus = ["Down"]; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["k"]; _children = [ { MoveFocus = ["Up"]; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["l"]; _children = [ { MoveFocus = ["Right"]; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["1"]; _children = [ { GoToTab = 1; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["2"]; _children = [ { GoToTab = 2; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["3"]; _children = [ { GoToTab = 3; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["4"]; _children = [ { GoToTab = 4; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["5"]; _children = [ { GoToTab = 5; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["6"]; _children = [ { GoToTab = 6; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["7"]; _children = [ { GoToTab = 7; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["8"]; _children = [ { GoToTab = 8; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["9"]; _children = [ { GoToTab = 9; } { SwitchToMode._args = ["locked"]; } ]; }; }
# 			# 		{ bind = { _args = ["q"]; Quit = {}; }; }
# 			# 		{ bind = { _args = ["Backspace"]; SwitchToMode._args = ["locked"]; }; }
# 			# 	];
# 			#
# 			# 	pane._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["L"];
# 			# 				NewPane = "right";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["J"];
# 			# 				NewPane = "down";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["h"];
# 			# 				MoveFocus = "Left";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["j"];
# 			# 				MoveFocus = "Down";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["k"];
# 			# 				MoveFocus = "Up";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["l"];
# 			# 				MoveFocus = "Right";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["r"];
# 			# 				SwitchToMode._args = ["resize"];
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["R"];
# 			# 				SwitchToMode._args = ["renamepane"];
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["f"];
# 			# 				ToggleFocusFullscreen = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["F"];
# 			# 				ToggleFloatingPanes = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["x"];
# 			# 				CloseFocus = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["m"];
# 			# 				SwitchToMode._args = ["move"];
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	resize._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["h"];
# 			# 				Resize = "Increase left";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["j"];
# 			# 				Resize = "Increase down";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["k"];
# 			# 				Resize = "Increase up";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["l"];
# 			# 				Resize = "Increase right";
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	move._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["h"];
# 			# 				MovePane = "left";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["j"];
# 			# 				MovePane = "down";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["k"];
# 			# 				MovePane = "up";
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["l"];
# 			# 				MovePane = "right";
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	tab._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["h"];
# 			# 				GoToPreviousTab = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["l"];
# 			# 				GoToNextTab = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["n"];
# 			# 				NewTab = {};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["x"];
# 			# 				CloseTab = {};
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	scroll._children = [];
# 			#
# 			# 	search._children = [];
# 			#
# 			# 	entersearch._children = [];
# 			#
# 			# 	renametab._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["Esc"];
# 			# 				_children = [
# 			# 					{ UndoRenameTab = {}; }
# 			# 					{ SwitchToMode._args = ["locked"]; }
# 			# 				];
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	renamepane._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["Esc"];
# 			# 				_children = [
# 			# 					{ UndoRenamePane = {}; }
# 			# 					{ SwitchToMode._args = ["locked"]; }
# 			# 				];
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	session._children = [
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["l"];
# 			# 				LaunchOrFocusPlugin = {
# 			# 					name = "session-manager";
# 			# 					floating = true;
# 			# 				};
# 			# 			};
# 			# 		}
# 			# 		{
# 			# 			bind = {
# 			# 				_args = ["d"];
# 			# 				Detach = {};
# 			# 			};
# 			# 		}
# 			# 	];
# 			#
# 			# 	tmux._children = [];
# 			#
# 			# 	"shared_except \"locked\"" = {
# 			# 		_children = [
# 			# 			{
# 			# 				bind = {
# 			# 					_args = ["Esc"];
# 			# 					SwitchToMode._args = ["locked"];
# 			# 				};
# 			# 			}
# 			# 			{
# 			# 				bind = {
# 			# 					_args = ["Backspace"];
# 			# 					SwitchToMode._args = ["normal"];
# 			# 				};
# 			# 			}
# 			# 		];
# 			# 	};
# 			# };
# 			#
# 			# plugins = {
# 			# 	session-manager = {
# 			# 		location = "zellij:session-manager";
# 			# 	};
# 			# 	tab-bar = {
# 			# 		location = "zellij:tab-bar";
# 			# 	};
# 			# 	status-bar = {
# 			# 		location = "zellij:status-bar";
# 			# 	};
# 			# 	strider = {
# 			# 		location = "zellij:strider";
# 			# 	};
# 			# 	compact-bar = {
# 			# 		location = "zellij:compact-bar";
# 			# 	};
# 			# 	welcome-screen = {
# 			# 		location = "zellij:session-manager";
# 			# 		welcome_screen = true;
# 			# 	};
# 			# 	filepicker = {
# 			# 		location = "zellij:strider";
# 			# 		cwd = "/";
# 			# 	};
# 			# };
# 			#
# 			# load_plugins = [
# 			# 	"zjstatus"
# 			# 	"zjstatus-hints"
# 			# ];
# 		};
# 	};
# }

