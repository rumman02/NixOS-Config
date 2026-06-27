{ ... }: {

	# ===========================================================================
	# EZA (A MODERN REPLACEMENT FOR LS)
	# ===========================================================================
	programs.eza = {
		enable = true;
		enableZshIntegration = true; # Create eza aliases in .zshrc
		enableBashIntegration = true; # Create eza aliases in .bashrc
	};
}