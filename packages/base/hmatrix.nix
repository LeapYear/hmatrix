{ mkDerivation, array, base, binary, bytestring, deepseq, random
, split, stdenv, storable-complex, vector
, openblas
, darwin
}:
let accelerateFramework =
      if stdenv.isDarwin
        then darwin.apple_sdk.frameworks.Accelerate
        else null;
in
mkDerivation {
  pname = "hmatrix";
  version = "0.18.0.0";
  src = ./.;
  libraryHaskellDepends = [
    array base binary bytestring deepseq random split storable-complex
    vector
  ];
  preConfigure = "sed -i hmatrix.cabal -e 's@/usr/@/dont/hardcode/paths/@'";
  buildDepends =
    if stdenv.isDarwin
      then [ accelerateFramework ]
      else [ openblas ];
  configureFlags = if stdenv.isDarwin then [] else [ "-fopenblas" ];

  homepage = "https://github.com/albertoruiz/hmatrix";
  description = "Numeric Linear Algebra";
  license = stdenv.lib.licenses.bsd3;
}
