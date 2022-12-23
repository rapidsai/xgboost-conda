#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION.

set -euo pipefail

source rapids-env-update

export CMAKE_GENERATOR=Ninja

export XGBOOST_REPO="dmlc/xgboost"
export XGBOOST_REF="v1.7.2"
export XGBOOST_VERSION="1.7.2"
export XGBOOST_BUILD_NUMBER="0"
export RAPIDS_VERSION="23.02"

rapids-print-env

rapids-logger "Begin py build"

rapids-mamba-retry mambabuild \
  --no-test \
  recipes/xgboost

rapids-upload-conda-to-s3 python
