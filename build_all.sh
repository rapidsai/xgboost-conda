#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH

source activate gdf

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/nvcc

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/xgboost recipes/dask-xgboost

conda build -c rapidsai-nightly -c rapidsai-nightly/label/xgboost -c rapidsai -c rapidsai/label/xgboost -c nvidia -c conda-forge -c defaults \
    recipes/xgboost recipes/dask-xgboost --output | xargs \
    anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai-nightly} --label xgboost --force