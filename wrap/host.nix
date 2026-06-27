# NOTE:
# "wgcf register" to get configuration
# "wgcf generate" to generate .conf file
#  make sure all into homedir

{ homedir, pkgs, ... }: {

	environment.etc."wireguard/warp.conf" = {
		source = "${homedir}/wgcf-profile.conf";
		mode = "0600";
	};

	environment.systemPackages = with pkgs; [
		warpd # related to 1.1.1.1
		wgcf # related to 1.1.1.1
		wireguard-tools
	];

	networking.wg-quick.interfaces.warp = {
		configFile = "/etc/wireguard/warp.conf";
		autostart = true;
	};
}

