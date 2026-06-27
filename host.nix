/* NOTE: here some links about to install in windows machine:
virtio-win is need when you not found the virtio drive in windows boot drive selet
1. virtio-win: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win.iso
2. spice guest tools: https://archive.org/download/spice-guest-tools/spice-guest-tools-latest.exe
4. vbios: https://www.techpowerup.com/vgabios/259632/Sapphire.RX6800XT.16384.211230.rom
*/

{ pkgs, username, homedir, configdir, ... }:
let
	cpu = "intel";
	gpuIDs = [
		"1002:73bf" # video
		"1002:ab28" # audio
	];

	windows_11 = {
		name,
		title,
		uuid,
		desc,
		cpuSocket? "1",
		cpuCore? "8",
		cpuThreads ? "2",
		cpu ? toString (1 * 8 * 2),
		ram ? toString (12 * 1024 * 1024),
		diskPath? "/var/lib/libvirt/images",
		diskName? "Windows_11.qcow2",
		diskSize? "128",
		diskFullPath ? "${diskPath}/${diskName}",
		isoPath ? "${homedir}/vm/iso/Win11.iso",
		virtioIsoPath ? "${homedir}/vm/iso/virtio-win.iso",
		macAddress? "52:54:00:68:c6:04",
		extraConfig,
	}:''
				# wait for libvirtd to be ready
				sleep 5

				# create directory for disk image
				mkdir -p ${diskPath}

				# only create vm if the vm doesn't exist
				if [ "${pkgs.libvirt}/bin/virsh -c qemu:///system list --all | awk 'NR==3 {print $2}')" != "${name}" ]; then

					# only create disk if the disk doesn't exist
					if [ ! -f "${diskFullPath}" ]; then
						${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "${diskFullPath}" "${diskSize}G"
					fi

# Create XML definition
cat > /tmp/${name}.xml << EOF
<domain type="kvm">
	<name>${name}</name>
	<uuid>${uuid}</uuid>
	<title>${title}</title>
	<description>${desc}</description>
	<metadata>
		<libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
		    <libosinfo:os id="http://microsoft.com/win/11"/>
		</libosinfo:libosinfo>
	</metadata>
	<memory unit="KiB">${ram}</memory>
	<currentMemory unit="KiB">${ram}</currentMemory>
	<memoryBacking>
		<source type="memfd"/>
		<access mode="shared"/>
	</memoryBacking>
	<vcpu placement="static">${cpu}</vcpu>
	<os firmware="efi">
		<type arch="x86_64" machine="pc-q35-10.0">hvm</type>
		<firmware>
			<feature enabled="no" name="enrolled-keys"/>
			<feature enabled="yes" name="secure-boot"/>
		</firmware>
		<loader readonly="yes" secure="yes" type="pflash" format="raw">${pkgs.qemu_kvm}/share/qemu/edk2-x86_64-secure-code.fd</loader>
		<nvram template="${pkgs.qemu_kvm}/share/qemu/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/${name}_VARS.fd</nvram>
	</os>
	<features>
		<acpi/>
		<apic/>
		<hyperv mode="custom">
			<relaxed state="on"/>
			<vapic state="on"/>
			<spinlocks state="on" retries="8191"/>
			<vpindex state="on"/>
			<runtime state="on"/>
			<synic state="on"/>
			<stimer state="on"/>
			<frequencies state="on"/>
			<tlbflush state="on"/>
			<ipi state="on"/>
			<evmcs state="on"/>
			<avic state="on"/>
		</hyperv>
		<vmport state="off"/>
		<smm state="on"/>
	</features>
	<cpu mode="host-passthrough" check="none" migratable="on">
		<topology sockets="${cpuSocket}" dies="${cpuSocket}" clusters="${cpuSocket}" cores="${cpuCore}" threads="${cpuThreads}"/>
	</cpu>
	<clock offset="localtime">
		<timer name="rtc" tickpolicy="catchup"/>
		<timer name="pit" tickpolicy="delay"/>
		<timer name="hpet" present="no"/>
		<timer name="hypervclock" present="yes"/>
	</clock>
	<on_poweroff>destroy</on_poweroff>
	<on_reboot>restart</on_reboot>
	<on_crash>destroy</on_crash>
	<pm>
		<suspend-to-mem enabled="no"/>
		<suspend-to-disk enabled="no"/>
	</pm>
	<devices>
		<emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
		<disk type="file" device="cdrom">
			<driver name="qemu" type="raw"/>
			<source file="${isoPath}"/>
			<target dev="sdb" bus="sata"/>
			<readonly/>
			<boot order="1"/>
			<address type="drive" controller="0" bus="0" target="0" unit="1"/>
		</disk>
		<disk type="file" device="cdrom">
			<driver name="qemu" type="raw"/>
			<source file="${virtioIsoPath}"/>
			<target dev="sdc" bus="sata"/>
			<readonly/>
			<boot order="2"/>
			<address type="drive" controller="0" bus="0" target="0" unit="2"/>
		</disk>
		<disk type="file" device="disk">
			<driver name="qemu" type="qcow2" cache="none" discard="unmap"/>
			<source file="${diskFullPath}"/>
			<target dev="vda" bus="virtio"/>
			<boot order="3"/>
			<address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
		</disk>
	<controller type="usb" index="0" model="qemu-xhci" ports="15">
		<address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
	</controller>
	<controller type="pci" index="0" model="pcie-root"/>
	<controller type="pci" index="1" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="1" port="0x10"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
	</controller>
	<controller type="pci" index="2" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="2" port="0x11"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
	</controller>
	<controller type="pci" index="3" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="3" port="0x12"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
	</controller>
	<controller type="pci" index="4" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="4" port="0x13"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
	</controller>
	<controller type="pci" index="5" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="5" port="0x14"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
	</controller>
	<controller type="pci" index="6" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="6" port="0x15"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
	</controller>
	<controller type="pci" index="7" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="7" port="0x16"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x6"/>
	</controller>
	<controller type="pci" index="8" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="8" port="0x17"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x7"/>
	</controller>
	<controller type="pci" index="9" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="9" port="0x18"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x0" multifunction="on"/>
	</controller>
	<controller type="pci" index="10" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="10" port="0x19"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x1"/>
	</controller>
	<controller type="pci" index="11" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="11" port="0x1a"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x2"/>
	</controller>
	<controller type="pci" index="12" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="12" port="0x1b"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x3"/>
	</controller>
	<controller type="pci" index="13" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="13" port="0x1c"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x4"/>
	</controller>
	<controller type="pci" index="14" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="14" port="0x1d"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x5"/>
	</controller>
	<controller type="sata" index="0">
		<address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
	</controller>
	<controller type="virtio-serial" index="0">
		<address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
	</controller>
    <interface type="network">
      <mac address="${macAddress}"/>
      <source network="default"/>
      <model type="virtio"/>
      <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
    </interface>
	<input type="mouse" bus="ps2"/>
	<input type="keyboard" bus="ps2"/>
	<tpm model="tpm-crb">
		<backend type="emulator" version="2.0">
	</backend>
	</tpm>
	<sound model="ich9">
		<address type="pci" domain="0x0000" bus="0x00" slot="0x1b" function="0x0"/>
	</sound>
	${extraConfig}
	<watchdog model="itco" action="reset"/>
	<memballoon model="virtio">
		<address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
	</memballoon>
	</devices>
</domain>
EOF
				${pkgs.libvirt}/bin/virsh define /tmp/${name}.xml
				rm /tmp/${name}.xml
					echo "VM ${name} created successfully with ${ram}GB RAM"
				else
					echo "VM ${name} already exists"
				fi
	'';

in {

	boot = {
		initrd = {
			kernelModules = [
				# "amdgpu"
			];
		};
		kernelModules = [
			"kvm-${cpu}"
			# "vfio"
			# "vfio_iommu_type1"
			# "vfio_virqfd"
		];
		kernelParams = [
			"${cpu}_iommu=on"
			"iommu=pt"
		];
		# ++ ("vfio-pci.ids=" + builtins.concatStringsSep "," gpuIDs);
	};

	environment = {
		systemPackages = with pkgs; [
			virtiofsd
		];
		variables = {
			LIBVIRT_DEFAULT_URI = "qemu:///system";
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
				ovmf = {
					enable = true;
					packages = [ pkgs.OVMFFull.fd ];
				};
			};
		};
		spiceUSBRedirection.enable = true;
	};

	systemd.services = {
		libvirtd = {
			enable = true;
			path = [
				(pkgs.buildEnv {
					name = "qemu-hook-env";
					paths = with pkgs; [
						virtiofsd
					];
				})
			];
			preStart = ''
				mkdir -p /var/lib/libvirt/hooks
		  		mkdir -p /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin
		  		mkdir -p /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end
		  		mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/prepare/begin
		  		mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/release/end
		  		# mkdir -p /var/lib/libvirt/vgabios

		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/qemu /var/lib/libvirt/hooks/qemu
		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/start.sh /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin/start.sh
		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/stop.sh /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end/stop.sh
		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/start.sh /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/prepare/begin/start.sh
		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/stop.sh /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/release/end/stop.sh

		  		ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/configs/kvm/kvm.conf /var/lib/libvirt/hooks/kvm.conf
		  		# ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/modules/vm/rom/Sapphire_RX6800XT.rom /var/lib/libvirt/vgabios/patched.rom

		  		chmod +x /var/lib/libvirt/hooks/qemu
		  		chmod +x /var/lib/libvirt/hooks/kvm.conf
		  		chmod +x /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin/start.sh
		  		chmod +x /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end/stop.sh
		  		chmod +x /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/prepare/begin/start.sh
		  		chmod +x /var/lib/libvirt/hooks/qemu.d/macOS_Sequoia_g/release/end/stop.sh
			'';
			# postStart = let
			# 	virsh = "${pkgs.libvirt}/bin/virsh";
			# in ''
			# 	sleep 2
			# 	# activating virtual network by default
			# 	${virsh} net-define ${pkgs.libvirt}/var/lib/libvirt/networks/default.xml || true
			# 	${virsh} net-autostart default || true
			# 	${virsh} net-start default || true
			# '';
		};

		windows_11_n = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			after = [ "libvirtd.service" ];
			wants = [ "libvirtd.service" ];
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
				User = "root";
			};
			script = windows_11 {
				name = "Window_11_n";
				title = "Windows_11_Normal";
				desc = "Windows 11 without gpu passthrough";
				uuid = "35178671-67b2-43d1-8c8f-215b546838e2";
				extraConfig = ''<serial type="pty">
		<target type="isa-serial" port="0">
			<model name="isa-serial"/>
		</target>
	</serial>
	<console type="pty">
		<target type="serial" port="0"/>
	</console>
	<channel type="spicevmc">
		<target type="virtio" name="com.redhat.spice.0"/>
		<address type="virtio-serial" controller="0" bus="0" port="1"/>
	</channel>
	<graphics type="spice" autoport="yes">
		<listen type="address"/>
		<image compression="off"/>
	</graphics>
	<audio id="1" type="spice"/>
	<video>
		<model type="qxl" ram="65536" vram="65536" vgamem="16384" heads="1" primary="yes"/>
		<alias name="video0"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
	</video>
	<redirdev bus="usb" type="spicevmc">
		<address type="usb" bus="0" port="1"/>
	</redirdev>
	<redirdev bus="usb" type="spicevmc">
		<address type="usb" bus="0" port="2"/>
	</redirdev>'';
			};
		};
		windows_11_g = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			after = [ "libvirtd.service" ];
			wants = [ "libvirtd.service" ];
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
				User = "root";
			};
			script = windows_11 {
				name = "Window_11_g";
				title = "Windows_11_Gpu";
				desc = "Windows 11 with gpu passthrough";
				uuid = "5cffd501-84d9-4092-aeac-5b22457782fc";
				extraConfig = let
					vbiosPath = "${configdir}/vm/vbios/Sapphire_RX6800XT.rom";
				in ''<controller type="pci" index="15" model="pcie-root-port">
		<model name="pcie-root-port"/>
		<target chassis="15" port="0x8"/>
		<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
	</controller>
	<controller type="pci" index="16" model="pcie-to-pci-bridge">
		<model name="pcie-pci-bridge"/>
		<address type="pci" domain="0x0000" bus="0x08" slot="0x00" function="0x0"/>
	</controller>
	<audio id="1" type="none"/>
	<hostdev mode="subsystem" type="pci" managed="yes">
		<source>
			<address domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
		</source>
		<rom file="${vbiosPath}"/>
		<address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
	</hostdev>
	<hostdev mode="subsystem" type="pci" managed="yes">
		<source>
			<address domain="0x0000" bus="0x03" slot="0x00" function="0x1"/>
		</source>
		<rom file="${vbiosPath}"/>
		<address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
	</hostdev>
	<hostdev mode="subsystem" type="pci" managed="yes">
		<source>
			<address domain="0x0000" bus="0x00" slot="0x14" function="0x0"/>
		</source>
		<address type="pci" domain="0x0000" bus="0x10" slot="0x02" function="0x0"/>
	</hostdev>'';
			};
		};
	};
	# virsh -c qemu:///system list --all
	# virsh -c qemu:///system list --all | awk 'NR==3 {print $2}'

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

	users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
	# virsh -c qemu:///system list --all
	# virsh -c qemu:///system list --all | awk 'NR==3 {print $2}'

	# systemd.services.libvirtd = {
	# 	path = let
	# 		env = pkgs.buildEnv {
	# 			name = "qemu-hook-env";
	# 			paths = with pkgs; [
	# 				bash
	# 				libvirt
	# 			];
	# 		};
	# 	in
	# 		[ env ];
	#
	# 	preStart =
	# 		''
	#   mkdir -p /var/lib/libvirt/hooks
	#   mkdir -p /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin
	#   mkdir -p /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end
	#   mkdir -p /var/lib/libvirt/vgabios
	#
	#   ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/qemu /var/lib/libvirt/hooks/qemu
	#   ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/start.sh /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin/start.sh
	#   ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/scripts/vm/stop.sh /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end/stop.sh
	#   ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/configs/kvm/kvm.conf /var/lib/libvirt/hooks/kvm.conf
	#   ln -sf /home/rumman/.nixos-config/hosts/rumman_dp/modules/vm/rom/Sapphire_RX6800XT.rom /var/lib/libvirt/vgabios/patched.rom
	#
	#   chmod +x /var/lib/libvirt/hooks/qemu
	#   chmod +x /var/lib/libvirt/hooks/kvm.conf
	#   chmod +x /var/lib/libvirt/hooks/qemu.d/Windows_11_g/prepare/begin/start.sh
	#   chmod +x /var/lib/libvirt/hooks/qemu.d/Windows_11_g/release/end/stop.sh
	#   '';
	# };

}

