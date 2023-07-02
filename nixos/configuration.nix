# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, outputs, lib, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    timeout = 10; # Wait 10 seconds before booting the default entry.
  };

  # Networking
  networking = {
    hostName = "nixos-ryans";
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ]; # Google DNS
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Internationalisation
  ## Clock
  time.timeZone = "America/Sao_Paulo";

  ## Locale
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
  };
  ## TTY Layout
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # Display Managers/Desktop Environments/Window Managers
  services.xserver = {
    ## Enable the X11 windowing system.
    enable = true;
    ## Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      ## Active right-click on gnome
      extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.touchpad]
        click-method='default'
      '';
    };
    videoDrivers = [ "amdgpu" ];
    ## Configure keymap in X11
    layout = "br";
    xkbVariant = "abnt2";
  };

  # Hardware
  ## Enable CUPS to print documents.
  services.printing.enable = true;

  ## Enable sound with pipewire.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  ## Enable touchpad support
  services.xserver.libinput.enable = true;

  # Packages 
  users.users.ryrden = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" ];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays =
    [ outputs.overlays.additions outputs.overlays.modifications ];

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      nodePackages.typescript
      nodePackages."@vue/cli"
      python3
      go
      jdk
      jre
    ];
    gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gedit # text editor
        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ]);
  };
  programs.dconf.enable = true;

  # Updating and Upgrading
  system.autoUpgrade = {
    enable = true;
    channel = "https://channels.nixos.org/nixos-unstable";
  };

  nix = {
    # Garbage Collection
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Flakes
    ## Enable a way to reference flake attributes in nixpkgs
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    ## Enable FLAKE support 
    settings.experimental-features = "nix-command flakes";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
