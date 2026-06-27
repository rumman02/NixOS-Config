# tahoe install packages download link
# https://swcdn.apple.com/content/downloads/26/38/093-37779-A_Y4733G5GHI/adlxnkoqzyrrzfl1r5krg7ql0cod8vpl5e/InstallAssistant.pkg

{ pkgs, homedir, configdir, ... }:
let
	macos_tahoe = {
		name,
		title,
		uuid,
		desc,
		cpuSocket? "1",
		cpuCore? "8",
		cpuThreads ? "2",
		cpu ? toString (1 * 8 * 2),
		ram ? toString (18 * 1024 * 1024),
		diskPath? "/var/lib/libvirt/images",
		diskName? "macOS_Tahoe.qcow2",
		diskSize? "128",
		diskFullPath ? "${diskPath}/${diskName}",
		isoPath ? "${homedir}/vm/iso/BaseSystem.img",
		bootPath ? "${homedir}/vm/boot/OpenCore.qcow2",
		macAddress? "00:16:cb:00:22:09",
		extraConfig,
		}:''
			# wait for libvirtd to be ready
			sleep 5

			# create directory for disk image
			mkdir -p ${diskPath}

			# only create vm if the vm doesn't exist
			if [ "${pkgs.libvirt}/bin/virsh -c qemu:///system list --all | awk 'NR==3 {print $2}')" != "${name}" ]; then

				# only create disk if the disk doesn't exist
				# if [ ! -f "${diskFullPath}" ]; then
				# 	${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "${diskFullPath}" "${diskSize}G"
				# fi

# Create XML definition
cat > /tmp/${name}.xml << EOF
<domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
	<name>${name}</name>
	<uuid>${uuid}</uuid>
	<title>${title}</title>
	<description>${desc}</description>
	<memory unit="KiB">${ram}</memory>
	<currentMemory unit="KiB">${ram}</currentMemory>
	<memoryBacking>
		<source type="memfd"/>
		<access mode="shared"/>
	</memoryBacking>
	<vcpu placement="static">${cpu}</vcpu>
	<os>
		<type arch="x86_64" machine="pc-q35-4.2">hvm</type>
		<loader readonly="yes" type="pflash" format="raw">${pkgs.OVMF.fd}/FV/OVMF_CODE.fd</loader>
		<nvram template="${pkgs.OVMF.fd}/FV/OVMF_VARS.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/macOS_Tahoe_VARS.fd</nvram>
		<boot dev="hd"/>
	</os>
	<features>
		<acpi/>
		<apic/>
	</features>
	<cpu mode="host-passthrough" check="none" migratable="on">
		<topology sockets="${cpuSocket}" dies="${cpuSocket}" clusters="${cpuSocket}" cores="${cpuCore}" threads="${cpuThreads}"/>
	</cpu>
	<clock offset="utc">
		<timer name="rtc" tickpolicy="catchup"/>
		<timer name="pit" tickpolicy="delay"/>
		<timer name="hpet" present="no"/>
	</clock>
	<on_poweroff>destroy</on_poweroff>
	<on_reboot>restart</on_reboot>
	<on_crash>restart</on_crash>
	<devices>
		<emulator>${pkgs.qemu_kvm}/bin/qemu-system-x86_64</emulator>
		<disk type="file" device="disk">
			<driver name="qemu" type="qcow2"/>
			<source file="${bootPath}"/>
			<target dev="sda" bus="sata"/>
			<address type="drive" controller="0" bus="0" target="0" unit="0"/>
		</disk>
		<disk type="file" device="disk">
			<driver name="qemu" type="raw"/>
			<source file="${isoPath}"/>
			<target dev="sdc" bus="sata"/>
			<address type="drive" controller="0" bus="0" target="0" unit="2"/>
		</disk>
  <!-- <disk type="file" device="disk">
			<driver name="qemu" type="qcow2" cache="none" discard="unmap"/>
			<source file="${diskFullPath}"/>
			<target dev="vda" bus="virtio"/>
			<address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
		</disk> -->
		<disk type="block" device="disk">
		  <driver name="qemu" type="raw" cache="none" io="native" discard="unmap"/>
		  <source dev="/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8_BTNH12341T6M512A"/>
		  <target dev="sdd" bus="sata"/>
		  <address type="drive" controller="0" bus="0" target="0" unit="3"/>
		</disk>
		<controller type="sata" index="0">
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
		</controller>
		<controller type="pci" index="0" model="pcie-root"/>
		<controller type="pci" index="1" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="1" port="0x8"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0" multifunction="on"/>
		</controller>
		<controller type="pci" index="2" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="2" port="0x9"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x1"/>
		</controller>
		<controller type="pci" index="3" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="3" port="0xa"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x2"/>
		</controller>
		<controller type="pci" index="4" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="4" port="0xb"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x3"/>
		</controller>
		<controller type="pci" index="5" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="5" port="0xc"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x4"/>
		</controller>
		<controller type="pci" index="6" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="6" port="0xd"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x5"/>
		</controller>
		<controller type="pci" index="7" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="7" port="0xe"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x6"/>
		</controller>
		<controller type="pci" index="8" model="pcie-root-port">
			<model name="pcie-root-port"/>
			<target chassis="8" port="0xf"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x7"/>
		</controller>
		<controller type="pci" index="9" model="pcie-to-pci-bridge">
			<model name="pcie-pci-bridge"/>
			<address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
		</controller>
		<controller type="usb" index="0" model="ich9-ehci1">
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1d" function="0x7"/>
		</controller>
		<controller type="usb" index="0" model="ich9-uhci1">
			<master startport="0"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1d" function="0x0" multifunction="on"/>
		</controller>
		<controller type="usb" index="0" model="ich9-uhci2">
			<master startport="2"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1d" function="0x1"/>
		</controller>
		<controller type="usb" index="0" model="ich9-uhci3">
			<master startport="4"/>
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1d" function="0x2"/>
		</controller>
		<filesystem type="mount" accessmode="passthrough">
			<driver type="virtiofs"/>
			<binary path="${pkgs.virtiofsd}/bin/virtiofsd"/>
			<source dir="${homedir}"/>
			<target dir="Host-Home"/>
		</filesystem>
		<interface type="network">
			<mac address="${macAddress}"/>
			<source network="default"/>
			<model type="virtio-net"/>
			<address type="pci" domain="0x0000" bus="0x09" slot="0x02" function="0x0"/>
		</interface>
		<input type="mouse" bus="ps2"/>
		<input type="keyboard" bus="ps2"/>
		<input type="keyboard" bus="usb">
			<address type="usb" bus="0" port="3"/>
		</input>
		<input type="tablet" bus="usb">
			<address type="usb" bus="0" port="4"/>
		</input>
		<!-- <sound model="ich9">
			<address type="pci" domain="0x0000" bus="0x00" slot="0x1b" function="0x0"/>
		</sound>
		<audio id="1" type="none"/> -->
		<audio id='1' type='sdl'>
			<input latency='100'/>
			<output latency='100'/>
		</audio>
		<sound model='virtio'>
		  <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
		</sound>
		${extraConfig}
		<watchdog model="itco" action="reset"/>
		<memballoon model="none"/>
	</devices>
	<qemu:commandline>
		<qemu:arg value="-global"/>
		<qemu:arg value="ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off"/>
		<qemu:arg value="-device"/>
		<qemu:arg value="isa-applesmc,osk=ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"/>
		<qemu:arg value="-smbios"/>
		<qemu:arg value="type=2"/>
		<qemu:arg value="-cpu"/>
		<qemu:arg value="Haswell-noTSX,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"/>
		<qemu:arg value="-smp"/>
		<qemu:arg value="threads=${cpuThreads},cores=${cpuCore},sockets=${cpuSocket}"/>
		<qemu:arg value="-global"/>
		<qemu:arg value="nec-usb-xhci.msi=off"/>
	</qemu:commandline>
</domain>
EOF
				${pkgs.libvirt}/bin/virsh define /tmp/${name}.xml
				rm -rf /tmp/${name}.xml
				echo "VM ${name} created successfully with ${ram}GB RAM"
			else
				echo "VM ${name} already exists"
			fi
		'';
in {
	systemd.services = {
		macOS_Tahoe_n = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			after = [ "libvirtd.service" ];
			wants = [ "libvirtd.service" ];
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
				User = "root";
			};
			script = macos_tahoe {
				name = "macOS_Tahoe_n";
				title = "macOS_Tahoe_Normal";
				desc = "macOS Tahoe without gpu passthrough";
				uuid = "cd1f5ed4-22cb-4b87-bb18-146247ce85de";
				ram = toString (8 * 1024 * 1024);
				extraConfig = ''<serial type="pty">
			<target type="isa-serial" port="0">
				<model name="isa-serial"/>
			</target>
		</serial>
		<console type="pty">
			<target type="serial" port="0"/>
		</console>
		<graphics type="spice">
			<listen type="none"/>
		</graphics>
		<video>
			<model type="virtio" heads="1" primary="yes">
				<acceleration accel3d="no"/>
			</model>
			<address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
		</video>'';
			};
		};
		macOS_Tahoe_g = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			after = [ "libvirtd.service" ];
			wants = [ "libvirtd.service" ];
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
				User = "root";
			};
			script = macos_tahoe {
				name = "macOS_Tahoe_g";
				title = "macOS_Tahoe_Gpu";
				desc = "macOS Tahoe with gpu passthrough";
				uuid = "fecdafa3-a77b-4527-9ff6-a9e06c65b6da";
				ram = toString (21 * 1024 * 1024);
				extraConfig = ''<hostdev mode="subsystem" type="pci" managed="yes">
			<source>
				<address domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
			</source>
			<rom file="/var/lib/libvirt/vgabios/patched.rom"/>
			<address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0" multifunction="on"/>
		</hostdev>
		<hostdev mode="subsystem" type="pci" managed="yes">
			<source>
				<address domain="0x0000" bus="0x03" slot="0x00" function="0x1"/>
			</source>
			<rom file="/var/lib/libvirt/vgabios/patched.rom"/>
			<address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x1"/>
		</hostdev>
		<hostdev mode="subsystem" type="pci" managed="yes">
			<source>
				<address domain="0x0000" bus="0x00" slot="0x14" function="0x0"/>
			</source>
			<address type="pci" domain="0x0000" bus="0x09" slot="0x01" function="0x0"/>
		</hostdev>'';
			};
		};
	};
}

