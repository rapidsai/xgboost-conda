#!/bin/bash

# http://xgboost.readthedocs.io/en/latest/build.html

#rm -f "${BUILD_PREFIX}/bin/nvcc"
#export PREFIX="${PREFIX}:${CUDA_HOME}/bin/nvcc"

if [[ $(uname) == Darwin ]]
then
    # this seems to be expected by clang when linking
    ln -s ${PREFIX}/lib/libomp.dylib ${PREFIX}/lib/libgomp.dylib
fi

export CUDF_ROOT="${PREFIX}"
export NCCL_ROOT="${PREFIX}"

cmake \
      -G "Unix Makefiles" \
      -D CMAKE_BUILD_TYPE:STRING="Release" \
      -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
      -D CMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
      -D USE_CUDA:BOOL=ON \
      -D CMAKE_CUDA_COMPILER:PATH="${CUDA_HOME}/bin/nvcc" \
      -D CMAKE_CUDA_HOST_COMPILER:PATH="${CXX}" \
      -D CUDA_USE_STATIC_CUDA_RUNTIME:BOOL=OFF \
      -D CUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF \
      -D CMAKE_CXX_STANDARD:STRING="14" \
      -D CMAKE_CUDA_FLAGS:STRING="" \
      -D USE_NCCL:BOOL=ON \
      -D NCCL_ROOT:PATH="${PREFIX}" \
      -D NCCL_INCLUDE_DIR:PATH="${PREFIX}/include" \
      -D BUILD_WITH_SHARED_NCCL:BOOL=ON \
      -D USE_CUDF:BOOL=ON \
      -D CUDF_ROOT:PATH="${PREFIX}" \
      -D CUDF_INCLUDE_DIR:PATH="${PREFIX}/include" \
      -D GPU_COMPUTE_VER:STRING="60;61;70;80" \
      -D PLUGIN_RMM=ON \
      -D RMM_ROOT="${PREFIX}" \
      "${SRC_DIR}"
make -j${CPU_COUNT} VERBOSE=1
