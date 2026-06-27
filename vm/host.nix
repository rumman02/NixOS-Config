/* NOTE: here some links about to install in windows machine:
virtio-win is need when you not found the virtio drive in windows boot drive selet
1. virtio-win: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win.iso
2. spice guest tools: https://archive.org/download/spice-guest-tools/spice-guest-tools-latest.exe
4. vbios: https://www.techpowerup.com/vgabios/259632/Sapphire.RX6800XT.16384.211230.rom
*/
/*  WARN: iGpu creates problem with reattach gpu to display manager, so, that
you need to disable iGpu from bios settings */

{ pkgs, username, homedir, configdir, ... }: {

	imports = [
		./windows.nix
		./macos.nix
	];

	boot = {
		kernelModules = [
			"kvm-intel"
		];
		kernelParams = [
			"intel_iommu=on"
			"iommu=pt"
		];
	 	extraModprobeConfig = ''
			options kvm_intel nested=1
	    '';
	};

	environment = {
		systemPackages = with pkgs; [
			# virtiofsd
			# virtio-win
			virt-viewer
		];
		variables = {
			LIBVIRT_DEFAULT_URI = "qemu:///system";
		};
	};

	# file share between host and macos guest via network
	services.samba = {
		enable = true;
		settings = {
			homes = {
				# set password by sudo smbpasswd -a your-username
				path = "${homedir}";
				browseable = "no";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
				"directory mask" = "0755";
			};
		};
	};
	networking = {
		firewall = {
			allowedTCPPorts = [ 139 445 ];
			allowedUDPPorts = [ 137 138 ];
		};
	};

	virtualisation = {
		libvirtd = {
			enable = true;
			package = pkgs.libvirt;
			onBoot = "ignore"; # "start"
			onShutdown = "shutdown";
			qemu = {
				runAsRoot = true;
				package = pkgs.qemu_kvm;
				swtpm.enable = true;
				# ovmf = {
				# 	enable = true;
				# 	packages = [ pkgs.OVMF.fd ];
				# };
			};
		};
		spiceUSBRedirection.enable = true;
	};

	systemd.services = {
		libvirtd = {
			enable = true;
			# enable access from hooks to bash, modprobe, systemctl, etc
			path = let
				env = pkgs.buildEnv {
					name = "qemu-hook-env";
					paths = with pkgs; [
						bash
						libvirt
						kmod
						systemd
					];
				};
			in [ env ];
			preStart = let
				vmNames = [
					"Windows_11_g"
					"macOS_Tahoe_g"
				];

				# helper function to create VM hook directories and scripts
				createVmHooks = vmName: ''
					# make ${vmName} gpu passthrough script begin
					mkdir -p /var/lib/libvirt/hooks/qemu.d/${vmName}/prepare/begin
					ln -sf ${configdir}/scripts/vm/start.sh /var/lib/libvirt/hooks/qemu.d/${vmName}/prepare/begin/start.sh
					chmod +x /var/lib/libvirt/hooks/qemu.d/${vmName}/prepare/begin/start.sh

					# make ${vmName} gpu passthrough script end
					mkdir -p /var/lib/libvirt/hooks/qemu.d/${vmName}/release/end
					ln -sf ${configdir}/scripts/vm/stop.sh /var/lib/libvirt/hooks/qemu.d/${vmName}/release/end/stop.sh
					chmod +x /var/lib/libvirt/hooks/qemu.d/${vmName}/release/end/stop.sh
				'';
				# generate all VM hooks
				vmHooksCommands = builtins.concatStringsSep "\n" (map createVmHooks vmNames);
			in ''
				# create qemu hooks
				mkdir -p /var/lib/libvirt/hooks
				ln -sf ${configdir}/scripts/vm/qemu /var/lib/libvirt/hooks/qemu
				chmod +x /var/lib/libvirt/hooks/qemu

				# move patched gpu rom
				mkdir -p /var/lib/libvirt/vgabios
				ln -sf ${configdir}/vm/vbios/rx6800xt.rom /var/lib/libvirt/vgabios/patched.rom

				${vmHooksCommands}

				ln -sf ${configdir}/vm/kvm/kvm.conf /var/lib/libvirt/hooks/kvm.conf
				chmod +x /var/lib/libvirt/hooks/kvm.conf
			'';
			postStart = let
				virsh = "${pkgs.libvirt}/bin/virsh";
			in ''
				sleep 2
				# activating virtual network by default
				${virsh} net-define ${pkgs.libvirt}/var/lib/libvirt/networks/default.xml || true
				${virsh} net-autostart default || true
				${virsh} net-start default || true
			'';
		};
	};

	programs = {
		virt-manager.enable = true;
		dconf = {
			enable = true;
			profiles = {
				user.databases = [
					{
						settings = {
							# creating a qemu/kvm connection for virt-manager by default
							"org/virt-manager/virt-manager/connections" = {
								autoconnect = ["qemu:///system"];
								uris = ["qemu:///system"];
							};
						};
					}
				];
			};
		};
	};

	# enable if nixos as guest
	/* services.qemuGuest.enable = true;
	services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest */

	users.groups.libvirtd.members = [ "${username}" ];
	users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
	hardware.enableRedistributableFirmware = true;
}

