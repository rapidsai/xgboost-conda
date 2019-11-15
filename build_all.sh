#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

version=`curl -s https://raw.githubusercontent.com/dmlc/xgboost/master/python-package/xgboost/VERSION`
export XGBOOST_VERSION=${version/-/.}

source activate gdf
conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost

conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost --output | xargs \
    anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} --label main --force
