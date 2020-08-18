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
compiler=${compiler:-'default'}
rev=${rev:-'default'}

packageRoot=${packageRoot:-'pkgs.nix-gitignore.gitignoreSource [ ] ./.'}
cabalName=${cabalName:-'replace'}

# Account in Cachix to use
cachixAccount=${cachixAccount:-'replaceWithProjectNameInCachix'}
# If key not provided (branch is not inside the central repo) - init CACHIX_SIGNING_KEY as empty
CACHIX_SIGNING_KEY=${CACHIX_SIGNING_KEY:-""}

allowInconsistentDependencies=${allowInconsistentDependencies:-'false'}
doJailbreak=${doJailbreak:-'false'}
doCheck=${doCheck:-'true'}

sdistTarball=${sdistTarball:-'false'}
buildFromSdist=${buildFromSdist:-'false'}

failOnAllWarnings=${failOnAllWarnings:-'false'}
buildStrictly=${buildStrictly:-'false'}

enableDeadCodeElimination=${enableDeadCodeElimination:-'false'}
disableOptimization=${disableOptimization:-'true'}
linkWithGold=${linkWithGold:-'false'}

enableLibraryProfiling=${enableLibraryProfiling:-'false'}
enableExecutableProfiling=${enableExecutableProfiling:-'false'}
doTracing=${doTracing:-'false'}
enableDWARFDebugging=${enableDWARFDebugging:-'false'}
doStrip=${doStrip:-'false'}

enableSharedLibraries=${enableSharedLibraries:-'true'}
enableStaticLibraries=${enableStaticLibraries:-'false'}
enableSharedExecutables=${enableSharedExecutables:-'false'}
justStaticExecutables=${justStaticExecutables:-'false'}
enableSeparateBinOutput=${enableSeparateBinOutput:-'false'}

checkUnusedPackages=${checkUnusedPackages:-'false'}
doHaddock=${doHaddock:-'false'}
doHyperlinkSource=${doHyperlinkSource:-'false'}
doCoverage=${doCoverage:-'false'}
doBenchmark=${doBenchmark:-'false'}
generateOptparseApplicativeCompletions=${generateOptparseApplicativeCompletions:-'false'}
# [ "binary1" "binary2" ] - should pass " quotes into Nix interpreter
executableNamesToShellComplete=${executableNamesToShellComplete:-'[ "replaceWithExecutableName" ]'}


withHoogle=${withHoogle:-'false'}
