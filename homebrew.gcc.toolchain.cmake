#
# Homebrew GCC on macOS. The unversioned `gcc` on PATH is Apple Clang.
#

if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
  set(HOMEBREW_PREFIX "/opt/homebrew")
else()
  set(HOMEBREW_PREFIX "/usr/local")
endif()

set(HOMEBREW_GCC_PREFIX "${HOMEBREW_PREFIX}/opt/gcc")

set(_qw_gcc_hints
  "${HOMEBREW_GCC_PREFIX}/bin"
  "${HOMEBREW_PREFIX}/bin"
)

file(GLOB _qw_gcc_bins LIST_DIRECTORIES false
  "${HOMEBREW_GCC_PREFIX}/bin/gcc-[0-9]*"
  "${HOMEBREW_PREFIX}/bin/gcc-[0-9]*"
)
list(FILTER _qw_gcc_bins INCLUDE REGEX "/gcc-[0-9]+$")
list(SORT _qw_gcc_bins COMPARE NATURAL ORDER DESCENDING)

if(_qw_gcc_bins)
  list(GET _qw_gcc_bins 0 _qw_gcc)
else()
  find_program(_qw_gcc
    NAMES gcc-15 gcc-14 gcc-13 gcc-12 gcc-11
    HINTS ${_qw_gcc_hints}
    NO_DEFAULT_PATH
  )
endif()

if(NOT _qw_gcc)
  message(FATAL_ERROR
    "Homebrew GCC toolchain: gcc-<version> not found. Install with `brew install gcc`.")
endif()

set(CMAKE_C_COMPILER "${_qw_gcc}")

get_filename_component(_qw_gcc_bin "${_qw_gcc}" DIRECTORY)
get_filename_component(_qw_gcc_name "${_qw_gcc}" NAME)
string(REGEX REPLACE "^gcc" "g++" _qw_gxx_name "${_qw_gcc_name}")
set(_qw_gxx "${_qw_gcc_bin}/${_qw_gxx_name}")
if(EXISTS "${_qw_gxx}")
  set(CMAKE_CXX_COMPILER "${_qw_gxx}")
endif()

if(EXISTS "${_qw_gcc_bin}/gcc-ar")
  set(CMAKE_AR "${_qw_gcc_bin}/gcc-ar" CACHE FILEPATH "" FORCE)
endif()
if(EXISTS "${_qw_gcc_bin}/gcc-ranlib")
  set(CMAKE_RANLIB "${_qw_gcc_bin}/gcc-ranlib" CACHE FILEPATH "" FORCE)
endif()

set(CMAKE_PREFIX_PATH "${HOMEBREW_GCC_PREFIX}" ${CMAKE_PREFIX_PATH})

execute_process(COMMAND xcrun --show-sdk-path OUTPUT_VARIABLE MACOS_SDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CMAKE_SYSROOT ${MACOS_SDK_PATH})

unset(_qw_gcc)
unset(_qw_gxx)
unset(_qw_gcc_bin)
unset(_qw_gcc_name)
unset(_qw_gxx_name)
unset(_qw_gcc_bins)
unset(_qw_gcc_hints)
