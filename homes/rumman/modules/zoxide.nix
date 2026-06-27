{ ... }: {

	# ===========================================================================
	# ZOXIDE (A FASTER WAY TO NAVIGATE YOUR FILESYSTEM)
	# ===========================================================================
	# Zoxide is a smart cd command that learns your habits.
	# ===========================================================================
	programs.zoxide = {
		enable = true;
		# Enable integration with Zsh for `z` command.
		enableZshIntegration = true;
		# Enable integration with Bash for `z` command.
		enableBashIntegration = true;
	};
}