{ pkgs, ... }: {
	home.packages = with pkgs; [ kanata ];
	xdg.configFile."kanata/config.kbd".source = ../configs/kanata/config.kbd;
}

