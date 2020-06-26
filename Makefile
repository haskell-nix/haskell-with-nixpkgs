all: default.nix

default.nix: dummy.cabal
	cabal2nix --shell . > $@
