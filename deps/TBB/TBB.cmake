bambustudio_add_cmake_project(
    TBB
    URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.5.0.zip"
    URL_HASH SHA256=83ea786c964a384dd72534f9854b419716f412f9d43c0be88d41874763e7bb47
    #PATCH_COMMAND ${PATCH_CMD} ${CMAKE_CURRENT_LIST_DIR}/0001-TBB-GCC13.patch
    # Removes the hard-coded /GL (blocks ARM64EC links) and guards TSX
    # intrinsics against ARM64EC. Both no-ops for other targets' behaviour:
    # dropping LTCG slightly reduces x64 optimization but keeps the same code.
    PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/patch_tbb.cmake
    CMAKE_ARGS
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        # ARM64EC: /FIintrin.h makes cl warn C4163 for x86-only intrinsics
        # (__rdtsc, _mm_mfence) that softintrin handles at link time; TBB's
        # default warnings-as-errors turns those fatal.
        -DTBB_STRICT=OFF
        -DTBB_BUILD_SHARED=OFF
        -DTBB_BUILD_TESTS=OFF
        -DTBB_TEST=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_DEBUG_POSTFIX=_debug
)

if (MSVC)
    add_debug_dep(dep_TBB)
endif ()


