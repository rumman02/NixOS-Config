{ ... }: {

	# ===========================================================================
	# BTOP (RESOURCE MONITOR)
	# ===========================================================================
	programs.btop = {
		enable = true;
		settings = {
			vim_keys = true;          # Enable vim keys
			rounded_corners = true;   # Use rounded corners
			update_ms = 100;          # Update interval in milliseconds
		};
	};
}