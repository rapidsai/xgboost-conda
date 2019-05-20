#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH

apt-get update -q
DRIVER_VER="396.44-1"
LIBCUDA_VER="396"
if [ "$CUDA" == "10.0" ]; then
  DRIVER_VER="410.72-1"
  LIBCUDA_VER="410"
fi
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  cuda-drivers=${DRIVER_VER} libcuda1-${LIBCUDA_VER}


source activate gdf

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/nvcc

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/xgboost recipes/dask-xgboost

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/xgboost recipes/dask-xgboost --output | xargs \
    anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai-nightly} --label xgboost --force