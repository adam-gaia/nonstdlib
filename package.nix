{pkgs, perSystem, ...}:
pkgs.stdenv.mkDerivation {
  pname = "nonstdlib";
  version = "1.0";

  src = ./.;

  buildInputs = [ ];
  installPhase = ''
    mkdir -p $out/share
    cp $src/nonstdlib.sh $out/share/nonstdlib.sh
    cp -r $src/src $out/share/
  '';

  meta = with pkgs.lib; {
    description = "(non) standard library of bash functions";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
