{flake, inputs, ...}:
let
  writeNonstdlibShellApplication = {system, name, text, runtimeInputs ? []}:
    let 
      pkgs = import inputs.nixpkgs { inherit system; };
      modifiedText = 
        ''
          set -Eeuo pipefail
          # shellcheck source=/dev/null
          source ${flake}/nonstdlib.sh

          ${text}
        '';
    in
      pkgs.writeShellApplication {inherit name runtimeInputs; text=modifiedText; };


in {
  inherit writeNonstdlibShellApplication;
}
