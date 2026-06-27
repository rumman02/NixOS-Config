{ config, pkgs, ... }: let
	inherit (config.lib.formats.rasi) mkLiteral;
	color = config.lib.stylix.colors;
	font = config.stylix.fonts.serif.name;
in {
	programs.rofi = {
		enable = true;
		cycle = false;
		location = "center";
		# font = "${font} 11";
		package = pkgs.rofi;
		plugins = with pkgs; [
			rofi-file-browser
			rofi-emoji
			rofi-calc
		];
		modes = [
			"drun"
			"filebrowser"
			"window"
			"emoji"
			"calc"
			"run"
			# "ssh"
		];
		extraConfig = {
			show-icons = true;
			display-drun = " Apps";
			display-run = " Run";
			display-filebrowser = " Files";
			display-window = " Windows";
			display-emoji = " Emojis";
			display-calc = " Calculator";
			display-ssh = " SSH";
			drun-display-format = "{name}";
			window-format = "{w} · {c} · {t}";
		};
		theme = {
			"*" = {
				# background = mkLiteral "#${color.base00}";
				# background-alt = mkLiteral "#282839FF";
				# foreground = mkLiteral "#${color.base05}";
				# selected = mkLiteral "#${color.base0D}";
				# active = mkLiteral "#${color.base0B}";
				# urgent = mkLiteral "#${color.base08}";
				# border-colour = mkLiteral "@selected";
				# handle-colour = mkLiteral "@selected";
				# background-color = mkLiteral "@background";
				# foreground-color = mkLiteral "@foreground";
				# alternate-background = mkLiteral "@background-alt";
				# normal-background = mkLiteral "@background";
				# normal-foreground = mkLiteral "@foreground";
				# urgent-background = mkLiteral "@urgent";
				# urgent-foreground = mkLiteral "@background";
				# active-background = mkLiteral "@active";
				# active-foreground = mkLiteral "@background";
				# selected-normal-background = mkLiteral "@selected";
				# selected-normal-foreground = mkLiteral "@background";
				# selected-urgent-background = mkLiteral "@active";
				# selected-urgent-foreground = mkLiteral "@background";
				# selected-active-background = mkLiteral "@urgent";
				# selected-active-foreground = mkLiteral "@background";
				# alternate-normal-background = mkLiteral "@background";
				# alternate-normal-foreground = mkLiteral "@foreground";
				# alternate-urgent-background = mkLiteral "@urgent";
				# alternate-urgent-foreground = mkLiteral "@background";
				# alternate-active-background = mkLiteral "@active";
				# alternate-active-foreground = mkLiteral "@background";
			};

			window = {
				transparency = "real";
				location = mkLiteral "center";
				anchor = mkLiteral "center";
				fullscreen = false;
				width = mkLiteral "800px";
				x-offset = mkLiteral "0px";
				y-offset = mkLiteral "0px";
				enabled = true;
				margin = mkLiteral "0px";
				padding = mkLiteral "0px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "10px";
				# border-color = mkLiteral "@border-colour";
				cursor = mkLiteral "default";
				# background-color = mkLiteral "@background-colour";
			};

			mainbox = {
				enabled = true;
				spacing = mkLiteral "10px";
				margin = mkLiteral "0px";
				padding = mkLiteral "20px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "0px 0px 0px 0px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "transparent";
				children = map mkLiteral [ "inputbar" "message" "custombox" ];
			};

			custombox = {
				spacing = mkLiteral "10px";
				# background-color = mkLiteral "@background-colour";
				# text-color = mkLiteral "@foreground-colour";
				orientation = mkLiteral "horizontal";
				children = map mkLiteral [ "mode-switcher" "listview" ];
			};

			inputbar = {
				enabled = true;
				spacing = mkLiteral "10px";
				margin = mkLiteral "0px";
				padding = mkLiteral "8px 12px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "8px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "@alternate-background";
				# text-color = mkLiteral "@foreground-colour";
				children = map mkLiteral [ "textbox-prompt-colon" "entry" ];
			};

			prompt = {
				enabled = true;
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			"textbox-prompt-colon" = {
				enabled = true;
				padding = mkLiteral "5px 0px";
				expand = false;
				str = "";
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			entry = {
				enabled = true;
				padding = mkLiteral "5px 0px";
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
				cursor = mkLiteral "text";
				placeholder = "Search...";
				placeholder-color = mkLiteral "inherit";
			};

			"num-filtered-rows" = {
				enabled = true;
				expand = false;
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			"textbox-num-sep" = {
				enabled = true;
				expand = false;
				str = "/";
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			"num-rows" = {
				enabled = true;
				expand = false;
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			"case-indicator" = {
				enabled = true;
				# background-color = mkLiteral "inherit";
				# text-color = mkLiteral "inherit";
			};

			listview = {
				enabled = true;
				columns = 1;
				lines = 8;
				cycle = true;
				dynamic = true;
				scrollbar = true;
				layout = mkLiteral "vertical";
				reverse = false;
				fixed-height = true;
				fixed-columns = true;
				spacing = mkLiteral "5px";
				margin = mkLiteral "0px";
				padding = mkLiteral "0px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "0px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "@foreground-colour";
				cursor = mkLiteral "default";
			};

			scrollbar = {
				handle-width = mkLiteral "5px";
				# handle-color = mkLiteral "@handle-colour";
				border-radius = mkLiteral "10px";
				# background-color = mkLiteral "@alternate-background";
			};

			element = {
				enabled = true;
				spacing = mkLiteral "10px";
				margin = mkLiteral "0px";
				padding = mkLiteral "10px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "8px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "@foreground-colour";
				cursor = mkLiteral "pointer";
			};

			"element normal.normal" = {
				# background-color = mkLiteral "var(normal-background)";
				# text-color = mkLiteral "var(normal-foreground)";
			};

			"element normal.urgent" = {
				# background-color = mkLiteral "var(urgent-background)";
				# text-color = mkLiteral "var(urgent-foreground)";
			};

			"element normal.active" = {
				# background-color = mkLiteral "var(active-background)";
				# text-color = mkLiteral "var(active-foreground)";
			};

			"element selected.normal" = {
				# background-color = mkLiteral "var(selected-normal-background)";
				# text-color = mkLiteral "var(selected-normal-foreground)";
			};

			"element selected.urgent" = {
				# background-color = mkLiteral "var(selected-urgent-background)";
				# text-color = mkLiteral "var(selected-urgent-foreground)";
			};

			"element selected.active" = {
				# background-color = mkLiteral "var(selected-active-background)";
				# text-color = mkLiteral "var(selected-active-foreground)";
			};

			"element alternate.normal" = {
				# background-color = mkLiteral "var(alternate-normal-background)";
				# text-color = mkLiteral "var(alternate-normal-foreground)";
			};

			"element alternate.urgent" = {
				# background-color = mkLiteral "var(alternate-urgent-background)";
				# text-color = mkLiteral "var(alternate-urgent-foreground)";
			};

			"element alternate.active" = {
				# background-color = mkLiteral "var(alternate-active-background)";
				# text-color = mkLiteral "var(alternate-active-foreground)";
			};

			"element-icon" = {
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "inherit";
				size = mkLiteral "24px";
				cursor = mkLiteral "inherit";
			};

			"element-text" = {
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "inherit";
				highlight = mkLiteral "inherit";
				cursor = mkLiteral "inherit";
				vertical-align = mkLiteral "0.5";
				horizontal-align = mkLiteral "0.0";
			};

			"mode-switcher" = {
				enabled = true;
				expand = false;
				orientation = mkLiteral "vertical";
				spacing = mkLiteral "10px";
				margin = mkLiteral "0px";
				padding = mkLiteral "0px 0px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "0px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "@foreground-colour";
			};

			button = {
				padding = mkLiteral "0px 20px 0px 20px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "8px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "@alternate-background";
				# text-color = mkLiteral "inherit";
				vertical-align = mkLiteral "0.5";
				horizontal-align = mkLiteral "0.0";
				cursor = mkLiteral "pointer";
			};

			"button selected" = {
				# background-color = mkLiteral "var(selected-normal-background)";
				# text-color = mkLiteral "var(selected-normal-foreground)";
			};

			message = {
				enabled = true;
				margin = mkLiteral "0px";
				padding = mkLiteral "0px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "0px 0px 0px 0px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "transparent";
				# text-color = mkLiteral "@foreground-colour";
			};

			textbox = {
				padding = mkLiteral "12px";
				border = mkLiteral "0px solid";
				border-radius = mkLiteral "8px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "@alternate-background";
				# text-color = mkLiteral "@foreground-colour";
				vertical-align = mkLiteral "0.5";
				horizontal-align = mkLiteral "0.0";
				highlight = mkLiteral "none";
				# placeholder-color = mkLiteral "@foreground-colour";
				blink = true;
				markup = true;
			};

			"error-message" = {
				padding = mkLiteral "10px";
				border = mkLiteral "2px solid";
				border-radius = mkLiteral "8px";
				# border-color = mkLiteral "@border-colour";
				# background-color = mkLiteral "@background-colour";
				# text-color = mkLiteral "@foreground-colour";
			};
		};
	};
}

