{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) { inherit system; };
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "guif-landingpage";
            src = ./.;
            buildInputs = [ pkgs.zola ];
            buildPhase = ''
              zola build --force
            '';
            installPhase = ''
              mkdir -p $out
              cp -r public $out/website
            '';
          };
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zola
          ];
        };
      }
    );
}
