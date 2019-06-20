#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

source activate gdf

conda build -c conda-forge -c defaults recipes/nvcc
conda build -c conda-forge -c defaults recipes/nvcc --output | xargs \
  anaconda -t ${NVIDIA_UPLOAD_KEY} upload -u ${NVIDIA_CONDA_USERNAME:-nvidia} --force

conda build -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults recipes/nccl
conda build -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults recipes/nccl --output | xargs \
  anaconda -t ${NVIDIA_UPLOAD_KEY} upload -u ${NVIDIA_CONDA_USERNAME:-nvidia} --force


conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost

conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost --output | xargs \
    anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} --label xgboost --force


    conda build -c /conda/envs/gdf/conda-bld/ -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME}:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
        recipes/xgboost recipes/dask-xgboost
