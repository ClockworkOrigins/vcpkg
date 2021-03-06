# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#
if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    message(STATUS "Warning: Dynamic building not supported. Building static.") # pixman does not export any symbols.
    set(VCPKG_LIBRARY_LINKAGE static)
endif()

include(vcpkg_common_functions)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/pixman-0.34.0)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.cairographics.org/releases/pixman-0.34.0.tar.gz"
    FILENAME "pixman-0.34.0.tar.gz"
    SHA512 81caca5b71582b53aaac473bc37145bd66ba9acebb4773fa8cdb51f4ed7fbcb6954790d8633aad85b2826dd276bcce725e26e37997a517760e9edd72e2669a6d
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists_pixman.txt DESTINATION ${SOURCE_PATH}/pixman)
file(RENAME ${SOURCE_PATH}/pixman/CMakeLists_pixman.txt ${SOURCE_PATH}/pixman/CMakeLists.txt)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()

# Copy the appropriate header files.
file(COPY
"${SOURCE_PATH}/pixman/pixman.h"
"${SOURCE_PATH}/pixman/pixman-accessor.h"
"${SOURCE_PATH}/pixman/pixman-combine32.h"
"${SOURCE_PATH}/pixman/pixman-compiler.h"
"${SOURCE_PATH}/pixman/pixman-edge-imp.h"
"${SOURCE_PATH}/pixman/pixman-inlines.h"
"${SOURCE_PATH}/pixman/pixman-private.h"
"${SOURCE_PATH}/pixman/pixman-version.h"
DESTINATION
${CURRENT_PACKAGES_DIR}/include
)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pixman)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pixman/COPYING ${CURRENT_PACKAGES_DIR}/share/pixman/copyright)

vcpkg_copy_pdbs()
