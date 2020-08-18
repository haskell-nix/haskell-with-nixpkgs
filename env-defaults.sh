#!/usr/bin/env bash

# NOTE: Script to easy import nix-build settings from env, useful for tooling env replication and the CI builds, relies on `default.nix` interface, which exposes Nixpkgs Haskell Lib interface

# The most strict error checking requirements
set -Eexuo pipefail

### NOTE: Section handles imports from env, these are settings for Nixpkgs.
### They use the `default.nix` interface, which exposes expose most of the Nixpkgs Haskell.lib API: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/haskell-modules/lib.nix
### Some of these options implicitly switch the dependent options.
### Documentation of this settings is mosly in `default.nix`, since most settings it Nixpkgs related
### Additional documentation is in Nixpkgs Haskell.lib: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/haskell-modules/lib.nix


# NOTE: If vars not imported - init the vars with default values
# Non-set/passed ''/'default' compiler setting means currently default GHC of Nixpkgs ecosystem.
export compiler=${compiler:-'default'}
export rev=${rev:-'default'}

export packageRoot=${packageRoot:-'pkgs.nix-gitignore.gitignoreSource [ ] ./.'}
export cabalName=${cabalName:-'replace'}

# Account in Cachix to use
export cachixAccount=${cachixAccount:-'replaceWithProjectNameInCachix'}
# If key not provided (branch is not inside the central repo) - init CACHIX_SIGNING_KEY as empty
export CACHIX_SIGNING_KEY=${CACHIX_SIGNING_KEY:-""}

export allowInconsistentDependencies=${allowInconsistentDependencies:-'false'}
export doJailbreak=${doJailbreak:-'false'}
export doCheck=${doCheck:-'true'}

export sdistTarball=${sdistTarball:-'false'}
export buildFromSdist=${buildFromSdist:-'false'}

export failOnAllWarnings=${failOnAllWarnings:-'false'}
export buildStrictly=${buildStrictly:-'false'}

export enableDeadCodeElimination=${enableDeadCodeElimination:-'false'}
export disableOptimization=${disableOptimization:-'true'}
export linkWithGold=${linkWithGold:-'false'}

export enableLibraryProfiling=${enableLibraryProfiling:-'false'}
export enableExecutableProfiling=${enableExecutableProfiling:-'false'}
export doTracing=${doTracing:-'false'}
export enableDWARFDebugging=${enableDWARFDebugging:-'false'}
export doStrip=${doStrip:-'false'}

export enableSharedLibraries=${enableSharedLibraries:-'true'}
export enableStaticLibraries=${enableStaticLibraries:-'false'}
export enableSharedExecutables=${enableSharedExecutables:-'false'}
export justStaticExecutables=${justStaticExecutables:-'false'}
export enableSeparateBinOutput=${enableSeparateBinOutput:-'false'}

export checkUnusedPackages=${checkUnusedPackages:-'false'}
export doHaddock=${doHaddock:-'false'}
export doHyperlinkSource=${doHyperlinkSource:-'false'}
export doCoverage=${doCoverage:-'false'}
export doBenchmark=${doBenchmark:-'false'}
export generateOptparseApplicativeCompletions=${generateOptparseApplicativeCompletions:-'false'}
# [ "binary1" "binary2" ] - should pass " quotes into Nix interpreter
export executableNamesToShellComplete=${executableNamesToShellComplete:-'[ "replaceWithExecutableName" ]'}


export withHoogle=${withHoogle:-'false'}
