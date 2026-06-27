# { pkgs, username, lib, config, ... }: let
#
# 	gpuIDs = [
# 		"1002:73bf" # amd gpu video
# 		"1002:ab28" # amd gpu audio
# 	];
# 	options.vfio.enable = with lib; mkEnableOption "Configure the machine for VFIO";
#
# 	config = let cfg = config.vfio;

# in {
#
# 	# imports = [ ./single_gpu_passthrough ];
# 	# virtualisation.singleGPUPassthrough.enable = true;
#
# 	boot = {
# 		kernelModules = [
# 			"kvm-intel"
# 			"vfio"
# 			"vfio_iommu_type1"
# 			"vfio_virqfd"
# 		];
# 		kernelParams = [
# 			"intel_iommu=on"
# 			"iommu=pt"
#       ] ++ lib.optional cfg.enable
#         # isolate the GPU
#         ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
# 	};
#
# 	virtualisation = {
# 		libvirtd = {
# 			enable = true;
# 			onBoot = "ignore"; # another option "start"
# 			onShutdown = "shutdown";
# 			qemu = {
# 				runAsRoot = true;
# 				swtpm.enable = true;
# 				ovmf = {
# 					enable = true;
# 					packages = [ pkgs.OVMF.fd ];
# 				};
# 			};
# 		};
# 	};
#
# 	programs.virt-manager.enable = true;
#
#
# # 	systemd.services.create-windows-vm = {
# # 		description = "Create Windows 11 VM automatically";
# # 		wantedBy = [ "multi-user.target" ];
# # 		after = [ "libvirtd.service" ];
# # 		wants = [ "libvirtd.service" ];
# # 		serviceConfig = {
# # 			Type = "oneshot";
# # 			RemainAfterExit = true;
# # 			User = "root";
# # 		};
# # 		script = let
# # 			vmName = "Windows_11_Normal";
# # 			uuid = "bf0a9b8d-2a50-4886-b8bd-abc65a45652a";
# # 			ramGB = 8; # RAM in GB
# # 			ramKiB = toString (ramGB * 1024 * 1024); # Convert GB to KiB
# # 			vcpus = "16";
# # 			diskPath = "/var/lib/libvirt/images/win11.qcow2";
# # 			isoPath = "/home/rumman/VM/ISO/Win11_24H2_English_x64.iso";
# # 			virtioIsoPath = "/home/rumman/VM/ISO/virtio-win-0.1.271.iso";
# # 			macAddress = "52:54:00:68:c6:04";
# # 		in ''
# # 	  # Wait for libvirtd to be ready
# # 	  sleep 5
# #
# # 	  # Create directory
# # 	  mkdir -p /var/lib/libvirt/images
# #
# # 	  # Only create if VM doesn't exist
# # 	  if ! ${pkgs.libvirt}/bin/virsh list --all | grep -q "${vmName}"; then
# # 		# Create disk image (120GB)
# # 			${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "${diskPath}" "120G"
# #
# # 		# Create XML definition
# # 		cat > /tmp/${vmName}.xml << EOF
# # <domain type="kvm">
# #   <name>${vmName}</name>
# #   <uuid>${uuid}</uuid>
# #   <title>${vmName}</title>
# #   <metadata>
# # 	<libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
# # 	  <libosinfo:os id="http://microsoft.com/win/11"/>
# # 	</libosinfo:libosinfo>
# #   </metadata>
# #   <memory unit="KiB">${ramKiB}</memory>
# #   <currentMemory unit="KiB">${ramKiB}</currentMemory>
# #   <memoryBacking>
# # 	<source type="memfd"/>
# # 	<access mode="shared"/>
# #   </memoryBacking>
# #   <vcpu placement="static">${vcpus}</vcpu>
# #   <os firmware="efi">
# # 	<type arch="x86_64" machine="pc-q35-10.0">hvm</type>
# # 	<firmware>
# # 	  <feature enabled="no" name="enrolled-keys"/>
# # 	  <feature enabled="yes" name="secure-boot"/>
# # 	</firmware>
# # 	<loader readonly="yes" secure="yes" type="pflash" format="raw">/nix/store/8fg38774hh8mysi8f0a259762i4mcgzx-qemu-host-cpu-only-10.0.3/share/qemu/edk2-x86_64-secure-code.fd</loader>
# # 	<nvram template="/nix/store/8fg38774hh8mysi8f0a259762i4mcgzx-qemu-host-cpu-only-10.0.3/share/qemu/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/Windows_11_VM_VARS.fd</nvram>
# #   </os>
# #   <features>
# # 	<acpi/>
# # 	<apic/>
# # 	<hyperv mode="custom">
# # 	  <relaxed state="on"/>
# # 	  <vapic state="on"/>
# # 	  <spinlocks state="on" retries="8191"/>
# # 	  <vpindex state="on"/>
# # 	  <runtime state="on"/>
# # 	  <synic state="on"/>
# # 	  <stimer state="on"/>
# # 	  <frequencies state="on"/>
# # 	  <tlbflush state="on"/>
# # 	  <ipi state="on"/>
# # 	  <evmcs state="on"/>
# # 	  <avic state="on"/>
# # 	</hyperv>
# # 	<vmport state="off"/>
# # 	<smm state="on"/>
# #   </features>
# #   <cpu mode="host-passthrough" check="none" migratable="on">
# # 	<topology sockets="1" dies="1" clusters="1" cores="8" threads="2"/>
# #   </cpu>
# #   <clock offset="localtime">
# # 	<timer name="rtc" tickpolicy="catchup"/>
# # 	<timer name="pit" tickpolicy="delay"/>
# # 	<timer name="hpet" present="no"/>
# # 	<timer name="hypervclock" present="yes"/>
# #   </clock>
# #   <on_poweroff>destroy</on_poweroff>
# #   <on_reboot>restart</on_reboot>
# #   <on_crash>destroy</on_crash>
# #   <pm>
# # 	<suspend-to-mem enabled="no"/>
# # 	<suspend-to-disk enabled="no"/>
# #   </pm>
# #   <devices>
# # 	<emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
# # 	<disk type="file" device="disk">
# # 	  <driver name="qemu" type="qcow2" cache="none" discard="unmap"/>
# # 	  <source file="${diskPath}"/>
# # 	  <target dev="vda" bus="virtio"/>
# # 	  <boot order="2"/>
# # 	  <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
# # 	</disk>
# # 	<disk type="file" device="cdrom">
# # 	  <driver name="qemu" type="raw"/>
# # 	  <source file="${isoPath}"/>
# # 	  <target dev="sdb" bus="sata"/>
# # 	  <readonly/>
# # 	  <boot order="1"/>
# # 	  <address type="drive" controller="0" bus="0" target="0" unit="1"/>
# # 	</disk>
# # 	<disk type="file" device="cdrom">
# # 	  <driver name="qemu" type="raw"/>
# # 	  <source file="${virtioIsoPath}"/>
# # 	  <target dev="sdc" bus="sata"/>
# # 	  <readonly/>
# # 	  <boot order="3"/>
# # 	  <address type="drive" controller="0" bus="0" target="0" unit="2"/>
# # 	</disk>
# # 	<controller type="usb" index="0" model="qemu-xhci" ports="15">
# # 	  <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
# # 	</controller>
# # 	<controller type="pci" index="0" model="pcie-root"/>
# # 	<!-- Simplified PCIe controllers - reduced from 14 to 6 -->
# # 	<controller type="pci" index="1" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="1" port="0x10"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
# # 	</controller>
# # 	<controller type="pci" index="2" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="2" port="0x11"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
# # 	</controller>
# # 	<controller type="pci" index="3" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="3" port="0x12"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
# # 	</controller>
# # 	<controller type="pci" index="4" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="4" port="0x13"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
# # 	</controller>
# # 	<controller type="pci" index="5" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="5" port="0x14"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
# # 	</controller>
# # 	<controller type="pci" index="6" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="6" port="0x15"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
# # 	</controller>
# # 	<controller type="sata" index="0">
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
# # 	</controller>
# # 	<interface type="network">
# # 	  <mac address="${macAddress}"/>
# # 	  <source network="default"/>
# # 	  <model type="virtio"/>
# # 	  <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
# # 	</interface>
# # 	<input type="mouse" bus="ps2"/>
# # 	<input type="keyboard" bus="ps2"/>
# # 	<tpm model="tpm-crb">
# # 	  <backend type="emulator" version="2.0"/>
# # 	</tpm>
# # 	<sound model="ich9">
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x1b" function="0x0"/>
# # 	</sound>
# # 	<audio id="1" type="none"/>
# # 	<video>
# # 	  <model type="qxl" ram="65536" vram="65536" vgamem="16384" heads="1" primary="yes"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
# # 	</video>
# # 	<!-- Removed watchdog as it's usually unnecessary for desktop VMs -->
# # 	<memballoon model="virtio">
# # 	  <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
# # 	</memballoon>
# #   </devices>
# # </domain>
# # EOF
# #
# # 		# Define VM in libvirt
# # 		${pkgs.libvirt}/bin/virsh define /tmp/${vmName}.xml
# # 		rm /tmp/${vmName}.xml
# # 			echo "VM ${vmName} created successfully with ${ramGB}GB RAM"
# # 		else
# # 			echo "VM ${vmName} already exists"
# # 		fi
# # 		'';
# # 	};
#
# # 	systemd.services.create-windows-vm = {
# # 		description = "Create Windows 11 VM automatically";
# # 		wantedBy = [ "multi-user.target" ];
# # 		after = [ "libvirtd.service" ];
# # 		wants = [ "libvirtd.service" ];
# # 		serviceConfig = {
# # 			Type = "oneshot";
# # 			RemainAfterExit = true;
# # 			User = "root";
# # 		};
# # 		script = let
# # 			vmName = "Windows_11_Normal";
# #
# # 			ramGB = 8; # RAM in GB
# # 			ramKiB = toString (ramGB * 1024 * 1024); # Convert GB to KiB
# # 			vcpus = "16";
# # 			diskPath = "/var/lib/libvirt/images/win11.qcow2";
# # 			isoPath = "/home/rumman/VM/ISO/Win11_24H2_English_x64.iso";
# # 			virtioIsoPath = "/home/rumman/VM/ISO/virtio-win-0.1.271.iso";
# # 			macAddress = "52:54:00:68:c6:04";
# # 		in ''
# # 	  # Wait for libvirtd to be ready
# # 	  sleep 5
# #
# # 	  # Create directory
# # 	  mkdir -p /var/lib/libvirt/images
# #
# # 	  # Only create if VM doesn't exist
# # 	  if ! ${pkgs.libvirt}/bin/virsh list --all | grep -q "${vmName}"; then
# # 		# Create disk image (120GB)
# # 			${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "${diskPath}" "120G"
# #
# # 		# Create XML definition
# # 		cat > /tmp/${vmName}.xml << EOF
# # <domain type="kvm">
# #   <name>${vmName}</name>
# #   <title>${vmName}</title>
# #   <metadata>
# # 	<libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
# # 	  <libosinfo:os id="http://microsoft.com/win/11"/>
# # 	</libosinfo:libosinfo>
# #   </metadata>
# #   <memory unit="KiB">${ramKiB}</memory>
# #   <currentMemory unit="KiB">${ramKiB}</currentMemory>
# #   <memoryBacking>
# # 	<source type="memfd"/>
# # 	<access mode="shared"/>
# #   </memoryBacking>
# #   <vcpu placement="static">${vcpus}</vcpu>
# #   <os firmware="efi">
# # 	<type arch="x86_64" machine="pc-q35-10.0">hvm</type>
# # 	<firmware>
# # 	  <feature enabled="no" name="enrolled-keys"/>
# # 	  <feature enabled="yes" name="secure-boot"/>
# # 	</firmware>
# # 	<loader readonly="yes" secure="yes" type="pflash" format="raw">/nix/store/8fg38774hh8mysi8f0a259762i4mcgzx-qemu-host-cpu-only-10.0.3/share/qemu/edk2-x86_64-secure-code.fd</loader>
# # 	<nvram template="/nix/store/8fg38774hh8mysi8f0a259762i4mcgzx-qemu-host-cpu-only-10.0.3/share/qemu/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/Windows_11_VM_VARS.fd</nvram>
# #   </os>
# #   <features>
# # 	<acpi/>
# # 	<apic/>
# # 	<hyperv mode="custom">
# # 	  <relaxed state="on"/>
# # 	  <vapic state="on"/>
# # 	  <spinlocks state="on" retries="8191"/>
# # 	  <vpindex state="on"/>
# # 	  <runtime state="on"/>
# # 	  <synic state="on"/>
# # 	  <stimer state="on"/>
# # 	  <frequencies state="on"/>
# # 	  <tlbflush state="on"/>
# # 	  <ipi state="on"/>
# # 	  <evmcs state="on"/>
# # 	  <avic state="on"/>
# # 	</hyperv>
# # 	<vmport state="off"/>
# # 	<smm state="on"/>
# #   </features>
# #   <cpu mode="host-passthrough" check="none" migratable="on">
# # 	<topology sockets="1" dies="1" clusters="1" cores="8" threads="2"/>
# #   </cpu>
# #   <clock offset="localtime">
# # 	<timer name="rtc" tickpolicy="catchup"/>
# # 	<timer name="pit" tickpolicy="delay"/>
# # 	<timer name="hpet" present="no"/>
# # 	<timer name="hypervclock" present="yes"/>
# #   </clock>
# #   <on_poweroff>destroy</on_poweroff>
# #   <on_reboot>restart</on_reboot>
# #   <on_crash>destroy</on_crash>
# #   <pm>
# # 	<suspend-to-mem enabled="no"/>
# # 	<suspend-to-disk enabled="no"/>
# #   </pm>
# #   <devices>
# # 	<emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
# # 	<disk type="file" device="disk">
# # 	  <driver name="qemu" type="qcow2" cache="none" discard="unmap"/>
# # 	  <source file="${diskPath}"/>
# # 	  <target dev="vda" bus="virtio"/>
# # 	  <boot order="2"/>
# # 	  <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
# # 	</disk>
# # 	<disk type="file" device="cdrom">
# # 	  <driver name="qemu" type="raw"/>
# # 	  <source file="${isoPath}"/>
# # 	  <target dev="sdb" bus="sata"/>
# # 	  <readonly/>
# # 	  <boot order="1"/>
# # 	  <address type="drive" controller="0" bus="0" target="0" unit="1"/>
# # 	</disk>
# # 	<disk type="file" device="cdrom">
# # 	  <driver name="qemu" type="raw"/>
# # 	  <source file="${virtioIsoPath}"/>
# # 	  <target dev="sdc" bus="sata"/>
# # 	  <readonly/>
# # 	  <boot order="3"/>
# # 	  <address type="drive" controller="0" bus="0" target="0" unit="2"/>
# # 	</disk>
# # 	<controller type="usb" index="0" model="qemu-xhci" ports="15">
# # 	  <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
# # 	</controller>
# # 	<controller type="pci" index="0" model="pcie-root"/>
# # 	<!-- Simplified PCIe controllers - reduced from 14 to 6 -->
# # 	<controller type="pci" index="1" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="1" port="0x10"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
# # 	</controller>
# # 	<controller type="pci" index="2" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="2" port="0x11"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
# # 	</controller>
# # 	<controller type="pci" index="3" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="3" port="0x12"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
# # 	</controller>
# # 	<controller type="pci" index="4" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="4" port="0x13"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
# # 	</controller>
# # 	<controller type="pci" index="5" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="5" port="0x14"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
# # 	</controller>
# # 	<controller type="pci" index="6" model="pcie-root-port">
# # 	  <model name="pcie-root-port"/>
# # 	  <target chassis="6" port="0x15"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
# # 	</controller>
# # 	<controller type="sata" index="0">
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
# # 	</controller>
# # 	<interface type="network">
# # 	  <mac address="${macAddress}"/>
# # 	  <source network="default"/>
# # 	  <model type="virtio"/>
# # 	  <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
# # 	</interface>
# # 	<input type="mouse" bus="ps2"/>
# # 	<input type="keyboard" bus="ps2"/>
# # 	<tpm model="tpm-crb">
# # 	  <backend type="emulator" version="2.0"/>
# # 	</tpm>
# # 	<sound model="ich9">
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x1b" function="0x0"/>
# # 	</sound>
# # 	<audio id="1" type="none"/>
# # 	<video>
# # 	  <model type="qxl" ram="65536" vram="65536" vgamem="16384" heads="1" primary="yes"/>
# # 	  <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
# # 	</video>
# # 	<!-- Removed watchdog as it's usually unnecessary for desktop VMs -->
# # 	<memballoon model="virtio">
# # 	  <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
# # 	</memballoon>
# #   </devices>
# # </domain>
# # EOF
# #
# # 		# Define VM in libvirt
# # 			${pkgs.libvirt}/bin/virsh define /tmp/${vmName}.xml
# # 		rm /tmp/${vmName}.xml
# # 			echo "VM ${vmName} created successfully with ${ramGB}GB RAM"
# # 		else
# # 			echo "VM ${vmName} already exists"
# # 		fi
# # 		'';
# # 	};
#
# 	environment.systemPackages = with pkgs; [
# 		# Add these for complete functionality:
# 		# qemu_kvm    # CLI tools
# 		# libvirt     # virsh command line tool
# 		# OVMFFull    # OVMF package
# 		# bridge-utils # Optional: for bridge networking
# 		# virtio-win # virtio win iso
# 	];
#
# 	users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
# }

# { pkgs, username, lib, ... }: let
# 	cpu = "intel";
# 	gpu = "amd";
# 	gpuIDs = [
# 		"1002:73bf" # video
# 		"1002:ab28" # audio
# 	];
# in {
# 	boot = {
# 		kernelModules = [
# 			"kvm-${cpu}"
# 			"vfio"
# 			"vfio_pci"
# 			"vfio_iommu_type1"
# 			"vfio_virqfd"
# 		];
# 		kernelParams = [
# 			"${cpu}_iommu=on"
# 			"iommu=pt"
# 			# "kvm.ignore_msrs=1"
# 		] ++ [
# 			"vfio-pci.ids=${lib.concatStringsSep "," gpuIDs}"
# 		];
# 	};
#
# 	virtualisation = {
# 		spiceUSBRedirection.enable = true;
# 		libvirtd = {
# 			enable = true;
# 			extraConfig = ''
# 				user=${username}
# 			'';
# 			onBoot = "ignore"; # don't boot any vm automatically on boot
# 			onShutdown = "shutdown"; # stop all running vm on shutdown
# 			qemu = {
# 				package = pkgs.qemu_kvm;
# 				ovmf = {
# 					enable = true;
# 					packages = [(pkgs.OVMF.override {
# 						secureBoot = true;
# 						tpmSupport = true;
# 					}).fd];
# 				};
# 			};
# 		};
# 	};
#
# 	programs.virt-manager.enable = true;
#
# 	users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
# }

