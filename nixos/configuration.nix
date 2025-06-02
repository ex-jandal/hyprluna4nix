# this is your system's configuration file.
# use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # you can import other nixos modules here
  imports = [
    # TODO: choice your correct drivers for cpu + gpu

    # |==> gpu moduals configurations <==|
    # for amd setups
    inputs.hardware.nixosModules.common-gpu-amd

    # for nvidia setups
    # inputs.hardware.nixosModules.common-gpu-nvidia

    # |==> cpu modules configurations <==|
    # for amd cpus
    inputs.hardware.nixosModules.common-cpu-amd

    # for intel cpus
    # inputs.hardware.nixosModules.common-cpu-intel

    # |==> others modules <==|
    inputs.hardware.nixosModules.common-pc-ssd

    # import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../hyprluna/requiered-packages.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # configure your nixpkgs instance
    config = {
      # disable if you don't want unfree packages
      allowunfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) 
      [
        pkgs.vscode # visual-studio-code-bin
      ];

    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # opinionated: disable global registry
      flake-registry = "";
      # workaround for https://github.com/nixos/nix/issues/9574
      nix-path = config.nix.nixPath;
      # automatically optimizes the nix store by hard-linking identical files.
      # this saves disk space by reducing redundancy.
      auto-optimise-store = true;
      # list of nix binary caches (substituters) to fetch pre-built packages from.
      # this significantly speeds up builds and installations by avoiding local compilation.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
    };
    # opinionated: disable channels
    channel.enable = false;

    # opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # TODO: set your hostname, timezone, and locale
  networking.hostName = "hyprluna4nix";
  time.timeZone = "asia/aden";
  i18n.defaultLocale = "en_us.utf-8";

  # FIXME: choice one of which to make NixOS bootable
  boot.loader = {
    # --------------------------------------------------------------------
    # bootloader configuration (uefi vs. legacy bios)
    #
    # choose one of the configurations below by uncommenting the relevant section.
    #
    # important: after switching, remember to check and potentially adjust your
    # `/boot/efi` mount point in your `hardware-configuration.nix` if needed!
    # --------------------------------------------------------------------

    # option 1: uefi boot (recommended for modern systems)
    # uncomment this entire block for uefi-based systems.

    /*
    efi = {
      # this mount point must match your efi system partition (esp)
      # as defined in your ./hardware-configuration.nix (e.g., /boot/efi).
      # WARN: so you have to make it as this one below
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };

    grub = {
      # enable grub for uefi.
      efiSupport = true;
      # set to "nodev" for uefi, as grub installs to the efi partition.
      device = "nodev";
      useOSProber = true;

      # uncomment this line if your system doesn't boot into nixos after install
      # when using uefi. this installs grub to a fallback path on the efi partition.
      # efiinstallasremovable = true;
    };
    */
    # option 2: legacy bios boot (for older systems or specific setups)
    # uncomment this entire block instead of the uefi options above.
    
    grub = {
      # disable uefi support for grub.
      efiSupport = false;
      # specify the disk device (e.g., "/dev/sda", "/dev/vda", "/dev/nvme0n1").
      # replace "your_boot_device_here" with your actual boot drive. 
      # INFO: you can fetch it form you main config: /etc/nixos/configuration.nix 
      device = "/dev/disk/by-label/BOOT"; # or with lowercase like "boot", so check
      useOSProber = true; # INFO: useful if you have other operating systems.
    };
  };

  # INFO: force allowing pipewire as a audio card driver
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # pipewire will provide a pulseaudio server
    wireplumber.enable = true;
  };

  # INFO: wifi driver
  networking.networkmanager.enable = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 53 ];
      allowedUDPPorts = [ 68 67 546 53 ];
    };

  # INFO: for bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  users.users = {
    # FIXME: change the username (hyluna4nix) to yours
    hyprluna4nix = {
      initialPassword = "123";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    };
  };

  # this setups a ssh server. very important if you're setting up a headless system.
  # INFO: feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/faq/when_do_i_update_stateversion
  system.stateVersion = "25.05";
}
