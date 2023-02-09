#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION.

set -euo pipefail

source rapids-env-update

export CMAKE_GENERATOR=Ninja

export RAPIDS_VERSION="23.02"
export XGBOOST_GIT_REPO="https://github.com/rapidsai/xgboost"
export XGBOOST_GIT_REF="branch-${RAPIDS_VERSION}"
export XGBOOST_VERSION="1.7.1dev.rapidsai${RAPIDS_VERSION}"
export XGBOOST_BUILD_NUMBER="2"

rapids-print-env

rapids-logger "Begin py build"

rapids-mamba-retry mambabuild \
  --no-test \
  recipes/xgboost

rapids-upload-conda-to-s3 python
