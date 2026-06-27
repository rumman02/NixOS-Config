{ config, pkgs, ... }: {
	home.activation.createIsoDir = config.lib.dag.entryAfter ["writeBoundary"] ''
	if [ ! -d ~/vm/iso ]; then
		mkdir -p ~/vm/iso
		echo "Created ~/vm/iso directory"
	fi

	if [ ! -d ~/vm/boot ]; then
		mkdir -p ~/vm/boot
		echo "Created ~/vm/boot directory"
	fi
	'';

	home.packages = with pkgs; [
		dmg2img
		wget
	];

	# dconf.settings = {
	# 	"org/virt-manager/virt-manager/connections" = {
	# 		autoconnect = ["qemu:///system"];
	# 		uris = ["qemu:///system"];
	# 	};
	# };
}

