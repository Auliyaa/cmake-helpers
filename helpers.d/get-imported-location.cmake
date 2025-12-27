include_guard(GLOBAL)

#
# locate an imported target.
# imported target location heuristic looks for (in order):
# - IMPORTED_LOCATION
# - IMPORTED_LOCATION_RELEASE
# - IMPORTED_LOCATION_RELWITHDEBINFO
# - IMPORTED_LOCATION_DEBUG
#
# first match is returned
#
function(cmake_get_imported_location ARG_OUT_VAR ARG_TARGET)
  cmake_parse_arguments(ARG "" "" "" ${ARGN})

  unset(${ARG_OUT_VAR} PARENT_SCOPE)

  get_target_property(IS_IMPORTED ${ARG_TARGET} IMPORTED)
  if(IS_IMPORTED)
    get_target_property(LOCATION ${ARG_TARGET} LOCATION)
    set(${ARG_OUT_VAR} ${LOCATION} PARENT_SCOPE)
  elseif(NOT ARG_IMPORTED_ONLY)
    set(${ARG_OUT_VAR} $<TARGET_FILE:${ARG_TARGET}> PARENT_SCOPE)
  endif(IS_IMPORTED)
endfunction(cmake_get_imported_location)