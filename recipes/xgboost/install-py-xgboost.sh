#!/bin/bash

pushd ${SRC_DIR}/python-package
  ${PYTHON} -m pip install . --no-deps --ignore-installed --no-cache-dir -vvv
popd
