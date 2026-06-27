{ pkgs, ... }: {
	home = {
		packages = with pkgs; [
			# warpd # related to 1.1.1.1
			# wgcf # related to 1.1.1.1
			# wireguard-tools
		];
	};
}

