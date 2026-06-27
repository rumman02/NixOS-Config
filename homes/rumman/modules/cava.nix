{ config, ... }: let
	color = config.lib.stylix.colors;
in {

	# ===========================================================================
	# CAVA (CONSOLE-BASED AUDIO VISUALIZER)
	# ===========================================================================
	programs.cava = {
		enable = true;
		settings = {
			general = {
				framerate = 120;
			};
			color = {
				gradient = 1;
				gradient_color_1 = "'#${color.base0E}'"; # pink
				gradient_color_2 = "'#${color.base0D}'"; # mauve/purple
				gradient_color_3 = "'#${color.base0C}'"; # blue
				gradient_color_4 = "'#${color.base0B}'"; # teal/cyan
				gradient_color_5 = "'#${color.base0A}'"; # green
				gradient_color_6 = "'#${color.base09}'"; # yellow
				gradient_color_7 = "'#${color.base08}'"; # peach/orange
				gradient_color_8 = "'#${color.base08}'"; # red
			};
		};
	};
}