{ mkDerivation, base, http-types, lib, wai, wai-conduit, wai-extra
, warp
}:
mkDerivation {
  pname = "yasmp";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base http-types wai wai-conduit wai-extra warp
  ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
