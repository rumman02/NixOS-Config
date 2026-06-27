{ pkgs, username, ... }: {
	stylix = {
		icons = {
			enable = true;
			package = pkgs.colloid-icon-theme;
			dark = "Colloid";
		};
		targets = {
			firefox = {
				profileNames = [ username ];
			};
			waybar.enable = false;
		};
	};

}

