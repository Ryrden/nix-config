# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ outputs, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [ ./global ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
