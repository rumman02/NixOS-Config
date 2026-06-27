{ ... }: {

	# ===========================================================================
	# CLIPHIST (CLIPBOARD HISTORY MANAGER)
	# ===========================================================================
	services.cliphist = {
		enable = true;
		allowImages = true; # Allow storing images in the clipboard history
	};
}