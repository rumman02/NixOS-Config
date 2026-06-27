{ pkgs, ... }: {
	# ===========================================================================
	# YAZI (TERMINAL FILE MANAGER)
	# ===========================================================================
	# Yazi is a fast terminal file manager based on non-blocking I/O.
	# ===========================================================================
	programs.yazi = {
		enable = true;
		enableZshIntegration = true;
		enableBashIntegration = true;
		# ===========================================================================
		# PLUGINS
		# ===========================================================================
		plugins = {
			git = pkgs.yaziPlugins.git;
			sudo = pkgs.yaziPlugins.sudo;
			mount = pkgs.yaziPlugins.mount;
		};
	};
}