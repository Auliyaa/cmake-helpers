#
# Qt: setup default variables for a Qt project
#
macro(cmake_setup_default_qt_project)
  cmake_parse_arguments(ARG "" "" "AUTOUIC_SEATCH_PATHS;MODULES" ${ARGN})

  # --------------------------------------
  # Qt / CMake automation
  # --------------------------------------
  set(CMAKE_AUTOMOC ON)
  set(CMAKE_AUTOUIC ON)
  set(CMAKE_AUTORCC ON)

  # --------------------------------------
  # additional paths to look for ui files.
  #  by default, cmake will look in the same folder as the cpp/h
  # --------------------------------------
  if(ARG_AUTOUIC_SEATCH_PATHS)
    set(CMAKE_AUTOUIC_SEARCH_PATHS ${ARG_AUTOUIC_SEATCH_PATHS})
  endif()

  # --------------------------------------
  # Qt modules to automatically find
  # --------------------------------------
  foreach(ARG_MODULE IN LISTS ARG_MODULES)
    find_package(${ARG_MODULE} CONFIG REQUIRED)
  endforeach()

  # --------------------------------------
  # forward to standard Qt macros
  # --------------------------------------
  qt_standard_project_setup()

  # --------------------------------------
  # cleanup
  # --------------------------------------
  unset(ARG_AUTOUIC_SEATCH_PATHS)
  unset(ARG_MODULE)
  unset(ARG_MODULES)

endmacro(cmake_setup_default_qt_project)