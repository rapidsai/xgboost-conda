#!/bin/bash
set -ex

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

if [ -z "$XGBOOST_VERSION" ]; then
    echo "XGBOOST_VERSION is not set"
    exit 1
fi

. /opt/conda/etc/profile.d/conda.sh
conda activate rapids

# Install `boa` for `mambabuild`
mamba install -y boa

conda info
conda config --show-sources
conda list --show-channel-urls

export RAPIDS_CONDA_BLD_ROOT_DIR='/tmp/conda-bld-workspace'
export RAPIDS_CONDA_BLD_OUTPUT_DIR='/tmp/conda-bld-output'

env  | sort

conda mambabuild \
  --python=$PYTHON \
  --croot=$RAPIDS_CONDA_BLD_ROOT_DIR \
  --output-folder=$RAPIDS_CONDA_BLD_OUTPUT_DIR \
  recipes/xgboost

PKGS_TO_UPLOAD=$(find "${RAPIDS_CONDA_BLD_OUTPUT_DIR}" -name "*.tar.bz2")

gpuci_retry anaconda \
  -t ${MY_UPLOAD_KEY} \
  upload \
  -u ${CONDA_USERNAME:-rapidsai} \
  --label main \
  --skip-existing \
  --no-progress \
  ${PKGS_TO_UPLOAD}
