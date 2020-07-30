all: default.nix

default.nix: release.cabal
	cabal2nix --shell . > $@
