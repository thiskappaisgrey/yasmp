{ mkDerivation, base, blaze-html, http-types, lib, scotty, wai
, wai-conduit, wai-extra, warp
}:
mkDerivation {
  pname = "yasmp";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base blaze-html http-types scotty wai wai-conduit wai-extra warp
  ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
