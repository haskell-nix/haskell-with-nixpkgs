#!/usr/bin/env bash

source ./env-defaults.sh

GHC_BUILD(){

  # Normal GHC build
  # GHC sometimes produces logs so big - that Travis terminates builds, so multiple --quiet
  # If $compiler provided - use the setting - otherwise - default.
  nix-build \
    --quiet --quiet \
    --argstr compiler "$compiler" \
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
    --arg withHoogle "$withHoogle"

}

BUILD_PROJECT(){


IFS=$'\n\t'

if [ ! "$compiler" = "ghcjs" ]
  then

    GHC_BUILD

  else

    nix-build \
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

./upd-nix.sh

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
