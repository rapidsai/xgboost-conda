#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION.

set -euo pipefail

source rapids-env-update

export CMAKE_GENERATOR=Ninja

rapids-print-env

rapids-logger "Begin py build"

rapids-mamba-retry mambabuild \
  --no-test \
  recipes/xgboost

rapids-upload-conda-to-s3 python
