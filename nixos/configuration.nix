# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      <home-manager/nixos>

      ./fonts.nix
			
			./audio.nix

			./memory.nix

      ./virt.nix

			#./disks.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
	boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use a kernel compatible with out-of-tree gamepad drivers (xpadneo/xone).
  # `linuxPackages_latest` can jump to versions where these modules lag behind.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "usbcore.autosuspend=-1" "usbhid.mousepoll=1" ];

  networking.hostName = "ellychan"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the Flake feature
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hardware
  powerManagement.cpuFreqGovernor = "performance";
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
  ];

	# Bluetooth
	hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
	services.blueman.enable = true;
	hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
  boot.blacklistedKernelModules = [ "hid_microsoft" ];

  # Enable Display Manager
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ellychan = {
    isNormalUser = true;
    description = "Ellychan";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "libvirtd" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
  home-manager.users.ellychan = import /home/ellychan/nixos-config/home-manager/home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
        vimAlias = true;
      };
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard
    git
    neovim
    mako
    grc
    protonup-qt

    melonDS

		streamcontroller # Streamdeck
    wowup-cf

    winboat

    # Development
    opencode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ellychan" ];
  };
  programs.steam.enable = true;
  services.flatpak.enable = true;


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Virtualisation
  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
  };
  users.extraGroups.docker.members = [ "ellychan" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
