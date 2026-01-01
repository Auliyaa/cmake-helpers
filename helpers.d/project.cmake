include_guard(GLOBAL)

#
# Setups a CMake project with common defaults
#
macro(cmake_setup_default_project)
  set(CMAKE_CXX_STANDARD 23)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

  # --------------------------------------
  # install paths
  # --------------------------------------
  if(WIN32)
    # override some definitions for windows, used before including GNUInstallDirs module
    set(CMAKE_INSTALL_LIBDIR bin)
  endif(WIN32)
  include(GNUInstallDirs)

  # --------------------------------------
  # RPATH
  # --------------------------------------
  if(NOT WIN32)
    set(CMAKE_INSTALL_RPATH
      "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
    )
  endif(NOT WIN32)

  # --------------------------------------
  # cmake config files helpers
  # --------------------------------------
  include(CMakePackageConfigHelpers)

  # --------------------------------------
  # pkg_check_modules
  # --------------------------------------
  if(NOT WIN32)
    find_package(PkgConfig REQUIRED)
  endif(NOT WIN32)

  # --------------------------------------
  # check_cxx_compiler_flag
  # --------------------------------------
  include(CheckCXXCompilerFlag)
endmacro(cmake_setup_default_project)

# --------------------------------------
# utility function: dump elements in a list
# --------------------------------------
function(cmake_dump_lst LIST)
  foreach(_ITM IN LISTS ${LIST})
    message(STATUS "  ${_ITM}")
  endforeach()
endfunction(cmake_dump_lst)

# --------------------------------------
# utility function to check support for compiler flags
# --------------------------------------
function(check_compiler_flags)
  cmake_parse_arguments(ARG "" "OUT" "UNIX_FLAGS;WIN32_FLAGS" ${ARGN})

  set(ARG_FLAGS ${ARG_UNIX_FLAGS})
  
  if(WIN32)
    set(ARG_FLAGS ${ARG_WIN32_FLAGS})
  endif(WIN32)

  foreach(ARG_FLAG IN LISTS ARG_FLAGS)
    message(STATUS "checking for flag: ${ARG_FLAG}")
    string(REPLACE "-" "_" FLAG_NAME "${ARG_FLAG}")
    string(TOUPPER "${FLAG_NAME}" FLAG_NAME)
    check_cxx_compiler_flag("${ARG_FLAG}" COMPILER_SUPPORTS_${FLAG_NAME})
    if(COMPILER_SUPPORTS_${FLAG_NAME})
      list(APPEND ${ARG_OUT} "${ARG_FLAG}")
    endif(COMPILER_SUPPORTS_${FLAG_NAME})
  endforeach()

  set(${ARG_OUT} ${${ARG_OUT}} PARENT_SCOPE)
endfunction(check_compiler_flags)

# --------------------------------------
# generate export module with default options
# assumes the exsistence of an export set in ${PROJECT_NAME}-exports
# --------------------------------------
macro(cmake_setup_default_export)
  cmake_parse_arguments(ARG "" "NAMESPACE" "" ${ARGN})

  if(NOT ARG_NAMESPACE)
    set(ARG_NAMESPACE "${PROJECT_NAME}")
  endif(NOT ARG_NAMESPACE)

  install(EXPORT ${PROJECT_NAME}-exports
    FILE ${PROJECT_NAME}Config.cmake
    NAMESPACE ${ARG_NAMESPACE}::
    DESTINATION cmake
    COMPONENT devel
  )

  write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake COMPATIBILITY SameMajorVersion)
  install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
    DESTINATION cmake
    COMPONENT devel
  )
endmacro()