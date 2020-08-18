#!/usr/bin/env bash

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

MAIN() {

# Travis GHCJS build
# By itself, GHCJS creates >65000 lines of log that are >4MB in size, so Travis terminates due to log size quota.
# nixbuild --quiet (x5) does not work on GHC JS build
# So there was a need to make it build.
# The solution is to silence the stdout
# But Travis then terminates on 10 min no stdout timeout
# so HACK: SILENT wrapper allows to surpress the huge log, while still preserves the Cachix caching ability in any case of the build
# On build failure outputs the last 10000 lines of log (that should be more then enough), and terminates
SILENT ./ghcjs-build.sh

}

# Run the entry function of the script
MAIN
