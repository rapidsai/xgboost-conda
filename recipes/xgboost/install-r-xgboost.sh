#!/bin/bash

if [[ ${OSTYPE} == msys ]]; then
  if [[ ${r_implementation} == mro-base ]]; then
    PREFIX=$(cygpath -u ${PREFIX})
    # TODO :: Shouldn't our Rtools package set this?
    export BINPREF=${PREFIX}/Rtools/mingw_64/bin/
  fi
fi

pushd ${SRC_DIR}/R-package
  # Remove src/Makevars.win because it says:
  # This file is only used for windows compilation from github
  # It will be replaced with Makevars.in for the CRAN version
  # rm src/Makevars.win
  ${R} CMD INSTALL --build .
popd
