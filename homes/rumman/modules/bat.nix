{ pkgs, ... }: {

	# ===========================================================================
	# BAT (A CAT CLONE WITH WINGS)
	# ===========================================================================
	programs.bat = {
		enable = true;

		# Bat configuration
		config = {
			# number = true;        # Show line numbers
			# grid = true;          # Show a grid
			# header = true;        # Show file header
			# wrap = "auto";        # "auto", "never", "character"
			# tabs = "4";           # Set tab width
			# show-all = true;      # Show non-printable characters
		};

		# Extra packages for bat
		extraPackages = with pkgs.bat-extras; [
			batdiff    # git diff with bat
			batman     # man pages with bat
			batgrep    # grep with bat
			batwatch   # watch with bat
		];
	};
}

