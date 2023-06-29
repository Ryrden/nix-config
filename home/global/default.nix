{ inputs, lib, pkgs, config, outputs, ... }:

{
  home = {
    username = "ryrden";
    homeDirectory = "/home/ryrden";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";
  };

  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true);
  };

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
