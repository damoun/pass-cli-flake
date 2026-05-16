{ stdenv
, lib
, fetchurl
, autoPatchelfHook
}:

let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
  version = versions.passCliVersions.version;

  # Map Nix systems to the keys used in versions.json
  systemMap = {
    "x86_64-linux" = { os = "linux"; arch = "x86_64"; };
    "aarch64-linux" = { os = "linux"; arch = "aarch64"; };
    "x86_64-darwin" = { os = "macos"; arch = "x86_64"; };
    "aarch64-darwin" = { os = "macos"; arch = "aarch64"; };
  };

  platform = systemMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  source = versions.passCliVersions.urls.${platform.os}.${platform.arch};

in
stdenv.mkDerivation {
  pname = "pass-cli";
  inherit version;

  src = fetchurl {
    url = source.url;
    sha256 = source.hash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
  ];

  # The source is a single pre-compiled binary
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/pass-cli
    runHook postInstall
  '';

  meta = with lib; {
    description = "Proton Pass CLI";
    homepage = "https://github.com/protonpass/pass-cli";
    license = licenses.mit; # The wrapper is MIT, the binary's license is upstream
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "pass-cli";
  };
}
