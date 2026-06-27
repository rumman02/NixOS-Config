{ lib, config, ... }:
let
	color = config.lib.stylix.colors;
	section_1 = color.base08;
	section_2 = color.base09;
	section_3 = color.base0A;
	section_4 = color.base0B;
	section_5 = color.base0D;
	section_6 = color.base0E;
	section_7 = color.base07;
	section_8 = color.base00; # text color
in
{
	programs.starship = {
		enable = true;
		enableBashIntegration = true;
		enableZshIntegration = true;
		settings = {
			add_newline = false;
			scan_timeout = 10;
			format = lib.concatStrings [
				"[░▒▓](#${section_1})"
				"$os"
				"$username"
				"[](bg:#${section_2} fg:#${section_1})"
				"$directory"
				"[](fg:#${section_2} bg:#${section_3})"
				"$git_branch"
				"$git_status"
				"[](fg:#${section_3} bg:#${section_4})"
				"$c"
				"$rust"
				"$golang"
				"$nodejs"
				"$php"
				"$java"
				"$kotlin"
				"$haskell"
				"$python"
				"$conda"
				"[](fg:#${section_4} bg:#${section_5})"
				"$docker_context"
				"[](fg:#${section_5} bg:#${section_6})"
				"$cmd_duration"
				"[](fg:#${section_6} bg:#${section_7})"
				"$time"
				"[](fg:#${section_7})"
				"$line_break$character"
			];
			os = {
				disabled = false;
				style = "bg:#${section_1} fg:#${section_8}";
				symbols = {
					Windows = " 󰍲 ";
					Ubuntu = " 󰕈 ";
					SUSE = "  ";
					Raspbian = " 󰐿 ";
					Mint = " 󰣭 ";
					Macos = "  ";
					Manjaro = "  ";
					Linux = " 󰌽 ";
					Gentoo = " 󰣨 ";
					Fedora = " 󰣛 ";
					Alpine = "  ";
					Amazon = "  ";
					Android = "  ";
					Arch = " 󰣇 ";
					Artix = " 󰣇 ";
					CentOS = "  ";
					Debian = " 󰣚 ";
					Redhat = " 󱄛 ";
					RedHatEnterprise = " 󱄛 ";
					NixOS = "  ";
				};
			};
			username = {
				show_always = true;
				style_user = "bg:#${section_1} fg:#${section_8}";
				style_root = "bg:#${section_1} fg:#${section_7}";
				format = "[ $user ]($style)";
			};
			directory = {
				style = "fg:#${section_8} bg:#${section_2}";
				format = "[ $path ]($style)";
				home_symbol = "~";
				truncation_length = 0;
				truncate_to_repo = false;
				truncation_symbol = "";
				substitutions = {
					Documents = "󰈙 ";
					Downloads = " ";
					Music = "󰝚 ";
					Pictures = " ";
					Developer = " ";
				};
			};
			git_status = {
				style = "fg:#${section_8} bg:#${section_3}";
				format = "[($all_status$ahead_behind) ]($style)";
			};
			git_branch = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_3}";
				format = "[ $symbol $branch ]($style)";
			};
			nodejs = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			c = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			rust = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			golang = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			php = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			java = {
				symbol = " ";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			kotlin = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			haskell = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			python = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[ $symbol ($version) ]($style)";
			};
			docker_context = {
				symbol = "";
				style = "fg:#${section_8} bg:#${section_5}";
				format = "[ $symbol ($context) ]($style)";
			};

			conda = {
				symbol = "  ";
				style = "fg:#${section_8} bg:#${section_4}";
				format = "[$symbol$environment ]($style)";
				ignore_base = false;
			};

			cmd_duration = {
				disabled = false;
				show_milliseconds = true;
				show_notifications = true;
				style = "fg:#${section_8} bg:#${section_6}";
				min_time = 2000;
				min_time_to_notify = 45000;
				format = "[ 󰓅 $duration ]($style)";
			};

			time = {
				disabled = false;
				time_format = "%r";
				style = "fg:#${section_8} bg:#${section_7}";
				format = "[ 󱑎 $time ]($style)";
			};

			line_break = {
				disabled = false;
			};

			character = {
				disabled = false;
				success_symbol = "[](bold fg:#${color.base0B})";
				error_symbol = "[](bold fg:#${color.base08})";
				vimcmd_symbol = "[](bold fg:#${color.base0B})";
				vimcmd_replace_one_symbol = "[](bold fg:#${color.base0E})";
				vimcmd_replace_symbol = "[](bold fg:#${color.base0E})";
				vimcmd_visual_symbol = "[](bold fg:#${color.base0D})";
			};
		};
	};
}

