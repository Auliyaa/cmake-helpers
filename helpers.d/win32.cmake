include_guard(GLOBAL)

#
# disable console for an application
#
function(win32_disable_console ARG_TARGET)
  if(WIN32)
    set_target_properties(${ARG_TARGET} PROPERTIES
      WIN32_EXECUTABLE ON
    )
  endif()
endfunction()

#
# install PDBs for a given target
#
function(win32_install_pdbs ARG_TARGET)
  if(MSVC)
    install(FILES $<TARGET_PDB_FILE:${ARG_TARGET}>
      DESTINATION ${CMAKE_INSTALL_BINDIR}
      OPTIONAL
    )
  endif()
endfunction()

#
# additional instructions to install Win32 Qt executables
#
function(win32_deploy_qt ARG_TARGET)
  if(WIN32)
    qt_generate_deploy_app_script(
      TARGET ${ARG_TARGET}
      OUTPUT_SCRIPT ${ARG_TARGET}_QTDEPLOY_SCRIPT
      NO_UNSUPPORTED_PLATFORM_ERROR
    )
    qt_finalize_executable(xdm1041-gui)
    install(SCRIPT "${${ARG_TARGET}_QTDEPLOY_SCRIPT}")
  endif()
endfunction()

#
# additional dlls to deploy for qt apps on windows
#
function(win32_install_global_qt_deps)
  if(WIN32)
    install(PROGRAMS
      ${CMAKE_BINARY_DIR}/zlibd1.dll
      ${CMAKE_BINARY_DIR}/zlib1.dll
      ${CMAKE_BINARY_DIR}/double-conversion.dll
      ${CMAKE_BINARY_DIR}/pcre2-16d.dll
      ${CMAKE_BINARY_DIR}/pcre2-16.dll
      ${CMAKE_BINARY_DIR}/zstd.dll
      ${CMAKE_BINARY_DIR}/harfbuzz.dll
      ${CMAKE_BINARY_DIR}/libpng16d.dll
      ${CMAKE_BINARY_DIR}/libpng16.dll
      ${CMAKE_BINARY_DIR}/freetyped.dll
      ${CMAKE_BINARY_DIR}/freetype.dll
      ${CMAKE_BINARY_DIR}/bz2d.dll
      ${CMAKE_BINARY_DIR}/bz2.dll
      ${CMAKE_BINARY_DIR}/brotlidec.dll
      ${CMAKE_BINARY_DIR}/brotlicommon.dll
      ${CMAKE_BINARY_DIR}/libcrypto-3-x64.dll
      DESTINATION ${CMAKE_INSTALL_BINDIR}
      OPTIONAL
    )
  endif()
endfunction()