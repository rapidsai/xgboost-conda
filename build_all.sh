#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

if [ -z "$XGBOOST_VERSION" ]; then
    echo "XGBOOST_VERSION is not set"
    exit 1
fi

# install gpuci tools
conda install -y -c gpuci gpuci-tools

# install build tools
conda install -y -c conda-forge conda-build conda-verify anaconda-client ripgrep

#conda build -c conda-forge -c defaults recipes/nvcc
#conda build -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults recipes/nccl

conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost recipes/dask-xgboost

conda build -c ${CONDA_USERNAME:-rapidsai} -c ${NVIDIA_CONDA_USERNAME:-nvidia} -c conda-forge -c defaults --python=$PYTHON  \
    recipes/xgboost --output > $WORKSPACE/conda-output

while read line ; do
    gpuci_retry anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} --label main --force $line
done < $WORKSPACE/conda-output
