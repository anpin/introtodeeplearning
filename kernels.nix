{self, pkgs, config, ...}:

let
  cfg = config.kernel.python.minimal;
in
 {
  kernel.python.minimal = {
    enable = true;
    # nixpkgs = self.inputs.nixpkgs-stable;
    # extraPackages = ps: [
    #   ps.tensorflow 
    #   ps.scipy 
    #   ps.matplotlib
    #   ];

    runtimePackages = [
      pkgs.coreutils
    ];
    env = cfg.nixpkgs.python312.withPackages (ps:
      with ps; [
        ps.tensorflow-bin
        ps.ipykernel
        ps.scipy
        ps.matplotlib
        # required for debugging mode
        ps.debugpy
      ]);
  };
}
