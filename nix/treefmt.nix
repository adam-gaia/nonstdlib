{
  projectRootFile = "flake.nix"; # Consider using "github:srid/flake-root" as described in https://nixos.asia/en/treefmt
  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
  };
}
