include_guard(GLOBAL)

#
# option_dep()
# wrapper around option() that allow us to dump all build options at once later on
# can also add dependencies that will automatically be enabled if the option is ON
# see option_dep_resolve()
#
# Example:
#
# option_dep(ENABLE_FOO "foo" OFF)
# option_dep(ENABLE_BAR "bar" OFF DEPENDS ENABLE_FOO)
# option_dep(ENABLE_FOOBAR "foobar" OFF DEPENDS ENABLE_BAR)
# option_dep_resolve()
#
# ..
#
# option_dep_dumps()
#
# - All options are off by default
# - Enabling ENABLE_BAR will set ENABLE_FOO to ON automatically
# - Enabling ENABLE_FOOBAR will set ENABLE_BAR to ON and then ENABLE_FOO to ON automatically.
#
macro(option_dep ARG_NAME)
  cmake_parse_arguments(ARG "" "" "DEPENDS" ${ARGN})

  option(${ARG_NAME} ${ARG_UNPARSED_ARGUMENTS})
  get_directory_property(_HAS_PARENT PARENT_DIRECTORY)

  # also has to be set in current scope
  set(_CMAKE_OPTIONS ${_CMAKE_OPTIONS} "${ARG_NAME}")
  set(_CMAKE_OPTION_DEPS_${ARG_NAME} ${ARG_DEPENDS})
  if(_HAS_PARENT)
    set(_CMAKE_OPTIONS ${_CMAKE_OPTIONS} PARENT_SCOPE)
    set(_CMAKE_OPTION_DEPS_${ARG_NAME} PARENT_SCOPE)
  endif(_HAS_PARENT)

  unset(_HAS_PARENT)
endmacro(option_dep)

#
# recursively resolve any dependencies given previously to option_dep
#
function(option_dep_resolve)
  cmake_add_termcolors()

  set(SOLVER_CONTINUE ON)
  while(SOLVER_CONTINUE)
    set(SOLVER_CONTINUE OFF)
    foreach(_CMAKE_OPTION IN LISTS _CMAKE_OPTIONS)
      if(NOT ${_CMAKE_OPTION} OR NOT _CMAKE_OPTION_DEPS_${_CMAKE_OPTION})
        continue()
      endif(NOT ${_CMAKE_OPTION} OR NOT _CMAKE_OPTION_DEPS_${_CMAKE_OPTION})

      foreach(DEP IN LISTS _CMAKE_OPTION_DEPS_${_CMAKE_OPTION})
        if(${DEP})
          # already enabled, skip
          continue()
        endif(${DEP})
        message(STATUS "${CMAKE_COLOR_YELLOW}(dependency solver)${CMAKE_COLOR_RESET} ${CMAKE_COLOR_BOLD}${_CMAKE_OPTION}${CMAKE_COLOR_RESET} enabling dependent option: ${CMAKE_COLOR_BOLD}${DEP}${CMAKE_COLOR_RESET}")
        set(${DEP} ON CACHE BOOL "" FORCE)
        set(SOLVER_CONTINUE ON)
      endforeach()
    endforeach()
  endwhile(SOLVER_CONTINUE)
endfunction(option_dep_resolve)

#
# Dump value of all options registered with option_dep
#
function(option_dep_dumps)
  cmake_add_termcolors()
  
  message(STATUS "Build options:")
  foreach(_CMAKE_OPTION IN LISTS _CMAKE_OPTIONS)
    if(NOT ${_CMAKE_OPTION})
      message(STATUS " -- ${CMAKE_COLOR_BOLD}${_CMAKE_OPTION}${CMAKE_COLOR_RESET}: ${CMAKE_COLOR_RED}${${_CMAKE_OPTION}}${CMAKE_COLOR_RESET}")
    else(NOT ${_CMAKE_OPTION})
      message(STATUS " -- ${CMAKE_COLOR_BOLD}${_CMAKE_OPTION}${CMAKE_COLOR_RESET}: ${CMAKE_COLOR_GREEN}${${_CMAKE_OPTION}}${CMAKE_COLOR_RESET}")
    endif(NOT ${_CMAKE_OPTION})
  endforeach()
endfunction(option_dep_dumps)

#
# Dump value of a specific variable
#
function(cmake_dump_variable)
  cmake_parse_arguments(ARG "" "NAME" "" ${ARGN})
  cmake_add_termcolors()
  
  if(NOT ${ARG_NAME})
    message(STATUS " -- ${CMAKE_COLOR_BOLD}${ARG_NAME}${CMAKE_COLOR_RESET}: ${CMAKE_COLOR_RED}undefined${CMAKE_COLOR_RESET}")
  else(NOT ${ARG_NAME})
    message(STATUS " -- ${CMAKE_COLOR_BOLD}${ARG_NAME}${CMAKE_COLOR_RESET}: ${CMAKE_COLOR_GREEN}${${ARG_NAME}}${CMAKE_COLOR_RESET}")
  endif(NOT ${ARG_NAME})
endfunction(cmake_dump_variable)