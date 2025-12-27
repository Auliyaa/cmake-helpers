include_guard(GLOBAL)

#
# enables clang-tidy checks for the specified target
#
function(add_clang_tidy)
  cmake_parse_arguments(ARG "" "TARGET" "CHECKS_ENABLED;CHECKS_DISABLED;OPTS" ${ARGN})

  if(NOT CLANG_TIDY_EXE)
    find_program(CLANG_TIDY_EXE clang-tidy REQUIRED)
  endif()

  if(NOT ARG_CHECKS_ENABLED)
    set(ARG_CHECKS_ENABLED
      "bugprone*"
      "cert*"
      "clang-analyzer*"
      "clang-diagnostic-unused-command-line-argument"
      "concurrency*"
      "cppcoreguidelines*"
      "cppcoreguidelines-pro-bounds-array-to-pointer-decay"
      "cppcoreguidelines-avoid-non-const-global-variables"
      "misc*"
      "modernize*"
      "performance*"
    )
  endif()

  if(NOT ARG_CHECKS_DISABLED)
    set(ARG_CHECKS_DISABLED
      "bugprone-easily-swappable-parameters"
      "bugprone-branch-clone"
      "cppcoreguidelines-avoid-c-arrays,modernize-avoid-c-arrays"
      "cppcoreguidelines-avoid-magic-numbers"
      "cppcoreguidelines-macro-usage"
      "cppcoreguidelines-pro-bounds-constant-array-index"
      "cppcoreguidelines-pro-bounds-pointer-arithmetic"
      "cppcoreguidelines-pro-type-reinterpret-cast"
      "misc-include-cleaner"
      "modernize-use-trailing-return-type"
      "modernize-avoid-c-arrays"
      "modernize-loop-convert"
      "cppcoreguidelines-no-malloc"
    )
  endif()

  if(NOT ARG_OPTS)
    set(ARG_OPTS
      "--extra-arg=-Wno-unused-command-line-argument"
      # "--dump-config"
    )
  endif()

  set(ARG_CHECKS_ALL ${ARG_CHECKS_ENABLED})
  foreach(C IN LISTS ARG_CHECKS_DISABLED)  
    list(APPEND ARG_CHECKS_ALL "-${C}")
  endforeach()
  list(JOIN ARG_CHECKS_ALL "," ARG_CHECKS_ALL_STR)

  set(CMAKE_CLANG_TIDY_CMD
    ${CLANG_TIDY_EXE}
    "-checks=${ARG_CHECKS_ALL_STR}"
    ${ARG_OPTS}
  )
  
  message(STATUS "enabling clang-tidy for target: ${TGT}")
  set_target_properties(${TGT} PROPERTIES CXX_CLANG_TIDY "${CMAKE_CLANG_TIDY_CMD}")

endfunction(add_clang_tidy TGT)