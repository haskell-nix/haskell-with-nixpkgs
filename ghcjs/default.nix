{ rpRef ? "ea3c9a1536a987916502701fb6d319a880fdec96" }:

let rp = builtins.fetchTarball "https://github.com/reflex-frp/reflex-platform/archive/${rpRef}.tar.gz";

in
  (import rp {}).project ({ pkgs, ... }:
  {
    name = "replaceWithPackageName";
    overrides = pkgs.lib.foldr pkgs.lib.composeExtensions (_: _: {})
                [
                ];
    packages = {
      hnix = ../.;
    };
    
    shells = {
      ghcjs = [ "hnix" ];
    };
  
  })
