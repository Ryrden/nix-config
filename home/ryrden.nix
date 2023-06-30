# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ outputs, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [ ./global ];

  # Use 'dconf watch /' to monitor changes to settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/background" = {
      picture-uri =
        "file:///home/ryrden/coding/nix-config/assets/wallpaper.png";
      picture-uri-dark =
        "file:///home/ryrden/coding/nix-config/assets/wallpaper.png";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri =
        "file:///home/ryrden/coding/nix-config/assets/lock-screen.png";
      picture-uri-dark =
        "file:///home/ryrden/coding/nix-config/assets/lock-screen.png";
    };
    # "org/gnome/shell" = {
    #   favorite-apps = [
    #     org.gnome.Nautilus.desktop
    #     console-solaris.desktop
    #     firefox.desktop
    #     spotify.desktop
    #     code.desktop
    #     tdesktop.desktop
    #     notion-web.desktop
    #     discord.desktop
    #   ];
    # };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Applications
    firefox
    spotify
    steam
    notion-web
    vlc # Video player
    transmission-gtk # Torrent client
    xournalpp
    discord

    # Utilities
    libsForQt5.okular # Okular (PDF Reader)
    gnome.pomodoro
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
    #android-studio

    #Tools
    #dbeaver
    mongodb
  ];

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
