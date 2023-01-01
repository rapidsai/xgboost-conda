#!/bin/bash

# https://xgboost.readthedocs.io/en/latest/build.html


export CUDF_ROOT="${PREFIX}"
export NCCL_ROOT="${PREFIX}"

CUDA_MAJOR=$(echo ${RAPIDS_CUDA_VERSION} | cut -f 1 -d.)

GPU_COMPUTE="60;70;75"
if [[ "$CUDA_MAJOR" -ge 11 ]]; then
    GPU_COMPUTE="$GPU_COMPUTE;80"
fi
echo "GPU_COMPUTE=$GPU_COMPUTE"

cmake \
      -G "Unix Makefiles" \
      -D CMAKE_BUILD_TYPE:STRING="Release" \
      -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
      -D CMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
      -D USE_CUDA:BOOL=ON \
      -D BUILD_WITH_CUDA_CUB:BOOL="ON" \
      -D CMAKE_CUDA_COMPILER:PATH="${CUDA_HOME}/bin/nvcc" \
      -D CMAKE_CUDA_HOST_COMPILER:PATH="${CXX}" \
      -D CUDA_USE_STATIC_CUDA_RUNTIME:BOOL=OFF \
      -D CUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF \
      -D CMAKE_CXX_STANDARD:STRING="17" \
      -D CMAKE_CUDA_FLAGS:STRING="" \
      -D USE_NCCL:BOOL=ON \
      -D NCCL_ROOT:PATH="${PREFIX}" \
      -D NCCL_INCLUDE_DIR:PATH="${PREFIX}/include" \
      -D BUILD_WITH_SHARED_NCCL:BOOL=ON \
      -D USE_CUDF:BOOL=ON \
      -D CUDF_ROOT:PATH="${PREFIX}" \
      -D CUDF_INCLUDE_DIR:PATH="${PREFIX}/include" \
      -D GPU_COMPUTE_VER:STRING="$GPU_COMPUTE" \
      -D PLUGIN_RMM=ON \
      -D RMM_ROOT="${PREFIX}" \
      "${SRC_DIR}"
make -j${CPU_COUNT} VERBOSE=1
