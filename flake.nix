{
  description = "Nix Flake for Proton Pass CLI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.callPackage ./package.nix { };

        apps.update = {
          type = "app";
          program = toString (pkgs.writeShellScript "update-pass-cli" ''
            PATH="${lib.makeBinPath [ pkgs.curl pkgs.jq pkgs.check-jsonschema pkgs.nix ]}:$PATH"
            ${./update.sh}
          '');
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
