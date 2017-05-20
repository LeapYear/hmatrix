{ mkDerivation, array, base, binary, bytestring, deepseq, random
, split, stdenv, vector
, openblasCompat
, darwin
}:
let
  accelerateFramework =
   if stdenv.isDarwin
     then darwin.apple_sdk.frameworks.Accelerate
     else null;
in
mkDerivation {
  pname = "hmatrix";
  version = "0.18.0.0";
  src = ./.;
  libraryHaskellDepends = [
    array base binary bytestring deepseq random split
    vector
  ];
  preConfigure = ''
    sed -i hmatrix.cabal -e 's@extra-lib-dirs@-- extra-lib-dirs@'
  '';
  librarySystemDepends =
    if stdenv.isDarwin
      then [ accelerateFramework ]
      else [ openblasCompat ];
  configureFlags = if stdenv.isDarwin then [] else [ "-fopenblas" ];

  homepage = "https://github.com/albertoruiz/hmatrix";
  description = "Numeric Linear Algebra";
  license = stdenv.lib.licenses.bsd3;
}
