{
  description = "Your jupyenv project";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  # inputs.flake-compat.url = "github:edolstra/flake-compat";
  # inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
  # inputs.jupyenv.url = "git+file:/home/a/projects/jupyenv?shallow=1";
  inputs.jupyenv.url = "github:anpin/jupyenv?ref=dev";
  # inputs.jupyenv.inputs.nixpkgs.follows = "nixpkgs";
  # inputs.jupyenv.inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";


  outputs = {
    self,
    # flake-compat,
    flake-utils,
    nixpkgs,
    jupyenv,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem
    [
      flake-utils.lib.system.x86_64-linux
    ]
    (
      system: let
        inherit (jupyenv.lib.${system}) mkJupyterlabNew;
        jupyterlab = mkJupyterlabNew ({...}: {
          nixpkgs = inputs.nixpkgs;
          imports = [(import ./kernels.nix)];
        });
      in rec {
        packages = {inherit jupyterlab;};
        packages.default = jupyterlab;
        apps.default.program = "${jupyterlab}/bin/jupyter-run";
        apps.default.type = "app";
        # devShells.default = mkShell
      }
    );
}
