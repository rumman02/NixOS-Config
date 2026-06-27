{ config, ... }: let
	color = config.lib.stylix.colors;
in
{
	programs.hyprlock = {
		enable = true;
		settings = {
			background = {
				blur_passes = 0; # 0 disable
				blur_size = 4;
				brightness = 0.8;
			};
			bezier = "linear, 1, 1, 0, 0";
			animation = "fade, 1, 1.8, linear";
			general = {
				hide_cursor = true;
				ignore_empty_input = true;
				no_fade_in = false;
				grace = 0;
				disable_loading_bar = false;
			};
			label = [
				{
					text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
					color = "rgba(216, 222, 233, 1)";
					font_size = 100;
					position = "50, 50";
					halign = "left";
					valign = "bottom";
				}
				{
					text = ''cmd[update:1000] echo -e "<span>$(date +"%A, %B %d")</span>"'';
					color = "rgba(216, 222, 233, 1)";
					font_size = 20;
					position = "65, 45";
					halign = "left";
					valign = "bottom";
				}
				# {
				#   text = ''$USER'';
				#   color = "${hexToRgba color.base06 0.2}";
				#   font_size = 12;
				#   font-family = "TX-02 Bold";
				#   position = "0, 60";
				#   halign = "center";
				#   valign = "bottom";
				# }
			];
			input-field = {
				font_size = 50;
				size = "200, 30";
				color = "rgba(216, 222, 233, 1)";
				outline_thickness = 2;
				fade_on_empty = true;
				hide_input = false;
				position = "0, 0";
				halign = "center";
				valign = "center";
			};
		};
	};
}

