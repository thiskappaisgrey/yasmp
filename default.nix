{ mkDerivation, aeson, base, beam-core, beam-sqlite, hspec
, hspec-contrib, http-types, lib, lucid, QuickCheck
, quickcheck-instances, scotty, sqlite-simple, text, time, wai
, wai-conduit, wai-extra, warp
}:
mkDerivation {
  pname = "yasmp";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base beam-core beam-sqlite http-types lucid scotty
    sqlite-simple text time wai wai-conduit wai-extra warp
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base hspec hspec-contrib QuickCheck quickcheck-instances text
  ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
