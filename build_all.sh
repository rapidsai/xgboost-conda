#!/bin/bash

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export HOME=$WORKSPACE

if [ -z "$XGBOOST_VERSION" ]; then
    echo "XGBOOST_VERSION is not set"
    exit 1
fi

# install gpuci tools
curl -s https://raw.githubusercontent.com/rapidsai/gpuci-tools/main/install.sh | bash

. /opt/conda/etc/profile.d/conda.sh
conda activate rapids

# Install `boa` for `mambabuild`
conda install -yq boa

# load gpuci tools
source ~/.bashrc

export RAPIDS_CONDA_BLD_ROOT_DIR='/tmp/conda-bld-workspace'
export RAPIDS_CONDA_BLD_OUTPUT_DIR='/tmp/conda-bld-output'

conda mambabuild --python=$PYTHON --croot=$RAPIDS_CONDA_BLD_ROOT_DIR --output-folder=$RAPIDS_CONDA_BLD_OUTPUT_DIR recipes/xgboost

PKGS_TO_UPLOAD=$(find "${RAPIDS_CONDA_BLD_OUTPUT_DIR}" -name "*.tar.bz2")

while read line ; do
    gpuci_retry anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} --label main --skip-existing $line
done < $PKGS_TO_UPLOAD
