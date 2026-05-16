{
  description = "Ruby dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux"; # or "aarch64-darwin", etc.
      pkgs = import nixpkgs { inherit system; };
    in
      {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          gcc
          gnumake
          libyaml
          openssl
          pkg-config
          readline
          ruby_4_0
          zlib
        ];

        shellHook = ''
          export GEM_HOME=$PWD/.gems
          export GEM_PATH=$GEM_HOME
          export PATH="$GEM_HOME/bin:$PATH"
          mkdir -p "$GEM_HOME"
          '';
      };
    };
}

