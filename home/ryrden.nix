# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ outputs, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [ ./global ];

  # Use 'dconf watch /' to monitor changes to settings
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "firefox.desktop"
        "code.desktop"
        "telegramdesktop.desktop"
        "spotify.desktop"
        "notion.desktop"
        "discord.desktop"
      ];
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "amarena";
      package = pkgs.amarena-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Applications
    spotify
    steam
    notion-web
    vlc # Video player
    transmission-gtk # Torrent client
    xournalpp
    discord

    # Utilities
    libsForQt5.okular # Okular (PDF Reader)
    obs-studio
    nixfmt

    # Communication
    tdesktop # Telegram

    # Development
    #Language
    gcc
    gnumake
    gdb
    bundler

    #Frameworks
    nodejs
    jekyll

    #IDEs
    vscode
    jetbrains.datagrip
    jetbrains.idea-community
    android-studio

    #Tools
    #dbeaver
    firefox
    google-chrome
  ];
  
  programs.git = {
    userName = "Ryan S.";
    userEmail = "ryansouza@usp.br";
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
