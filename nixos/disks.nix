{ config, pkgs, ... }:

{
	# Enable udisks2 (backend for drive management)
	services.udisks2.enable = true;

	# Enable udiskie for hot-mounting
	services.udiskie = {
		enable = true;
		automount = true;
		tray = true;
		notify = true;
	};

  # Add user groups needed for mounting without sudo
	users.users.ellychan.extraGroups = [ "wheel" "storage" "disk" "plugdev" ];

	# Helpful tools to have around
	environment.systemPackages = with pkgs; [
	  udiskie
		udisks2
		e2fsprogs # fsck, mkfs.ext4, etc.
		util-linux # mount, umount, lsblk, etc.
	];
}

