#
# Original source from: https://github.com/melonDS-emu/melonDS/blob/master/cmake/Toolchain-Homebrew-LLVM.cmake
#

# Detect homebrew llvm
if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(HOMEBREW_LLVM_PREFIX "/opt/homebrew/opt/llvm") # for apple silicon
else()
  set(HOMEBREW_LLVM_PREFIX "/usr/local/opt/llvm") # for intel
endif()

set(CMAKE_PREFIX_PATH ${HOMEBREW_LLVM_PREFIX} ${CMAKE_PREFIX_PATH})

set(CMAKE_C_COMPILER "${HOMEBREW_LLVM_PREFIX}/bin/clang")
set(CMAKE_CXX_COMPILER "${HOMEBREW_LLVM_PREFIX}/bin/clang++")

set(CMAKE_AR "${HOMEBREW_LLVM_PREFIX}/bin/llvm-ar" CACHE FILEPATH "" FORCE)
set(CMAKE_RANLIB "${HOMEBREW_LLVM_PREFIX}/bin/llvm-ranlib" CACHE FILEPATH "" FORCE)

execute_process(COMMAND xcrun --show-sdk-path OUTPUT_VARIABLE MACOS_SDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CMAKE_SYSROOT ${MACOS_SDK_PATH})
