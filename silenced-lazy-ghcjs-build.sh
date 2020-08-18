#!/usr/bin/env bash

# NOTE: Script to easy import nix-build settings from env, useful for tooling env replication and the CI builds, relies on `default.nix` interface, which exposes Nixpkgs Haskell Lib interface

# The most strict error checking requirements
set -Eexuo pipefail

compiler=${compiler:-'ghcjs'}
rev=${rev:-'default'}

packageRoot=${packageRoot:-'pkgs.nix-gitignore.gitignoreSource [ ] ./.'}
cabalName=${cabalName:-'replace'}

cachixAccount=${cachixAccount:-'replaceWithProjectNameInCachix'}
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
executableNamesToShellComplete=${executableNamesToShellComplete:-'[ "replaceWithExecutableName" ]'}


withHoogle=${withHoogle:-'false'}

# Log file to dump GHCJS build into
ghcjsTmpLogFile=${ghcjsTmpLogFile:-'/tmp/ghcjsTmpLogFile.log'}
# Length of the GHCJS log tail (<40000)
ghcjsLogTailLength=${ghcjsLogTailLength:-'10000'}


GHCJS_BUILD(){
# NOTE: Function for GHCJS build that outputs its huge log into a file

  # Run the build into Log (log is too long for Travis)
  "$@" &> "$ghcjsTmpLogFile"

}

SILENT(){
# NOTE: Function that silences the build process
# In normal mode outputs only the /nix/store paths

  echo "Log: $ghcjsTmpLogFile"
  # Pass into the ghcjsbuild function the build command
  if GHCJS_BUILD "$@"
  then

    # Output log lines for stdout -> cachix caching
    grep '^/nix/store/' "$ghcjsTmpLogFile"

  else

    # Output log lines for stdout -> cachix caching
    grep '^/nix/store/' "$ghcjsTmpLogFile"

    # Propagate the error state, fail the CI build
    exit 1

  fi

}

BUILD_PROJECT(){


IFS=$'\n\t'

if [ "$compiler" = "ghcjs" ]
  then

    # GHCJS build
    # By itself, GHCJS creates >65000 lines of log that are >4MB in size, so Travis terminates due to log size quota.
    # nixbuild --quiet (x5) does not work on GHC JS build
    # So there was a need to make it build.
    # The solution is to silence the stdout
    # But Travis then terminates on 10 min no stdout timeout
    # so HACK: SILENT wrapper allows to surpress the huge log, while still preserves the Cachix caching ability in any case of the build
    # On build failure outputs the last 10000 lines of log (that should be more then enough), and terminates
    SILENT nix-build \
      --argstr rev "$rev" \
      --arg allowInconsistentDependencies "$allowInconsistentDependencies" \
      --arg doJailbreak "$doJailbreak" \
      --arg doCheck "$doCheck" \
      --arg sdistTarball "$sdistTarball" \
      --arg buildFromSdist "$buildFromSdist" \
      --arg failOnAllWarnings "$failOnAllWarnings" \
      --arg buildStrictly "$buildStrictly" \
      --arg enableDeadCodeElimination "$enableDeadCodeElimination" \
      --arg disableOptimization "$disableOptimization" \
      --arg linkWithGold "$linkWithGold" \
      --arg enableLibraryProfiling "$enableLibraryProfiling" \
      --arg enableExecutableProfiling "$enableExecutableProfiling" \
      --arg doTracing "$doTracing" \
      --arg enableDWARFDebugging "$enableDWARFDebugging" \
      --arg doStrip "$doStrip" \
      --arg doHyperlinkSource "$doHyperlinkSource" \
      --arg enableSharedLibraries "$enableSharedLibraries" \
      --arg enableStaticLibraries "$enableStaticLibraries" \
      --arg enableSharedExecutables "$enableSharedExecutables" \
      --arg justStaticExecutables "$justStaticExecutables" \
      --arg checkUnusedPackages "$checkUnusedPackages" \
      --arg doCoverage "$doCoverage" \
      --arg doHaddock "$doHaddock" \
      --arg doBenchmark "$doBenchmark" \
      --arg generateOptparseApplicativeCompletions "$generateOptparseApplicativeCompletions" \
      --arg executableNamesToShellComplete "$executableNamesToShellComplete" \
      --arg withHoogle "$withHoogle" \
      "$compiler"

fi
}

MAIN() {


# Overall it is useful to have in CI test builds the latest stable Nix
(nix-channel --update && nix-env -u) || (sudo nix upgrade-nix) || true


# Report the Nixpkgs channel revision
nix-instantiate --eval -E 'with import <nixpkgs> {}; lib.version or lib.nixpkgsVersion'


# Secrets are not shared to PRs from forks
# nix-build | cachix push <account> - uploads binaries, runs&works only in the branches of the main repository, so for PRs - else case runs

  if [ ! "$CACHIX_SIGNING_KEY" = "" ]

    then

      # Build of the inside repo branch - enable push Cachix cache
      BUILD_PROJECT | cachix push "$cachixAccount"

    else

      # Build of the side repo/PR - can not push Cachix cache
      BUILD_PROJECT

  fi

}

# Run the entry function of the script
MAIN
