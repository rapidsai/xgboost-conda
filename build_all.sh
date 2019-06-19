#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

source activate gdf

# conda build -c conda-forge -c defaults recipes/nvcc
# conda build -c conda-forge -c defaults recipes/nccl

conda build -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost

conda build -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults --python=$PYTHON \
    recipes/xgboost recipes/dask-xgboost --output | xargs \
    anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai-nightly} --label xgboost --force
