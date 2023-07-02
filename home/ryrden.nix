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
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "space-bar@luchrioh"
        "dash-to-panel@jderose9.github.com"
        "pomodoro@arun.codito.in"
        "clipboard-indicator@tudmotu.com"
        "Vitals@CoreCoding.com"
      ];

    };

    "org/gnome/shell/extensions/space-bar" = { enable = true; };
    "org/gnome/shell/extensions/Vitals" = {
      enable = true;
      memory = true;
      temperature = true;
      network = true;
      gpu = true;
      sensorsInterval = 1;
    };
    "org/gnome/shell/extensions/cliboard-indicator" = { enable = true; };
    "org/gnome/shell/extensions/dash-to-panel" = { enable = true; };
    "org/gnome/shell/extensions/pomodoro" = { enable = true; };
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

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
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
    gnomeExtensions.user-themes
    gnomeExtensions.space-bar
    gnomeExtensions.dash-to-panel
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
    gnome.pomodoro

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
    #android-studio

    #Tools
    #dbeaver
    mongodb
  ];

  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = { ExtensionSettings = { }; };
    };
  };

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
