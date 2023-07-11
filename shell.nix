let
  commit = "022caabb5f2265ad4006c1fa5b1ebe69fb0c3faf";
  nixpkgs = fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${commit}.tar.gz";
    sha256 = "12q00nbd7fb812zchbcnmdg3pw45qhxm74hgpjmshc2dfmgkjh4n";
  };
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
  buildInputs = with pkgs; [ nodejs-12_x jdk11 openvpn mongodb vscode ];
}
