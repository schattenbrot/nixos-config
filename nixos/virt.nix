{ pkgs, ... }:

{
	programs.virt-manager.enable = true;

	users.groups.libvirtd.members = [ "ellychan" ];

	virtualisation.libvirtd.enable = true;

	virtualisation.spiceUSBRedirection.enable = true;
}
