{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pyproject-nix.url = "github:nix-community/pyproject.nix";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      pyproject-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          python = pkgs.python312;
          getAttrsValue = name: value: value;
        in
        {
          packages.default =
            let
              project = pyproject-nix.lib.project.loadPyproject {
                projectRoot = ./.;
              };
              attrs = project.renderers.buildPythonPackage { inherit python; };
            in
            python.pkgs.buildPythonPackage attrs;

          devShells =
            let
              dev-packages = import ./nix/dev.nix {
                pkgs = pkgs;
                python = python;
              };
            in
            {
              default = pkgs.mkShell {
                name = "pet-protect-infra-dev-env";
                # The Nix packages provided in the environment
                packages = (pkgs.lib.attrsets.mapAttrsToList getAttrsValue dev-packages);
                shellHook = ''
                  just devenv
                  source .venv/bin/activate
                '';
              };

              ci =
                let
                  ci-packages = import ./nix/ci.nix {
                    pkgs = pkgs;
                    python = python;
                  };
                  tox-project = pyproject-nix.lib.project.loadPyproject {
                    projectRoot = pkgs.fetchFromGitHub {
                      owner = "tox-dev";
                      repo = "tox-gh";
                      rev = "ea2191adcf8757d76dc4cee4039980859f39b01e";
                      sha256 = "sha256-uRNsTtc7Fr95fF1XvW/oz/qBQORpvCt/Lforpd6VZtk=";
                    };
                  };
                  tox-gh-attrs = tox-project.renderers.buildPythonPackage { inherit python; };
                  tox-gh = python.pkgs.buildPythonPackage (tox-gh-attrs // { version = "1.3.2"; });
                in
                pkgs.mkShell {
                  name = "pet-protect-infra-ci-env";
                  # The Nix packages provided in the environment
                  packages = (pkgs.lib.attrsets.mapAttrsToList getAttrsValue ci-packages) ++ [ tox-gh ];
                };
            };
        };
    };
}
