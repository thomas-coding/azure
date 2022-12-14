cmake_minimum_required(VERSION 3.0.0)

# Set up the project
project(thomas_m33
    LANGUAGES C ASM
)

set(TARGET "thomas_m33")
enable_language( C ASM )

include(config.cmake)

# Define ThreadX user configuration
set(TX_USER_FILE "${CMAKE_CURRENT_LIST_DIR}/tx_user.h" CACHE STRING "Enable TX user configuration")

# Include
include_directories(.)
include_directories(../../threadx/common/inc)
include_directories(../../threadx/ports/cortex_m33/gnu/inc)
include_directories(../../filex/common/inc)
include_directories(../../filex/ports/cortex_m33/gnu/inc)

# Run threadx on secure mode, no normal world
if(${CONFIG_TX_SINGLE_MODE_SECURE})
add_definitions(-DTX_SINGLE_MODE_SECURE)
endif()

# Run threadx on non-secure mode
if(${CONFIG_TX_SINGLE_MODE_NON_SECURE})
add_definitions(-DTX_SINGLE_MODE_NON_SECURE)
endif()

# Add azure kernel and components
if(${CONFIG_USBX})
    add_subdirectory(../../usbx usb)
    link_libraries(usbx)
endif()

if(${CONFIG_NETXDUO})
    add_subdirectory(../../netxduo netduo)
    link_libraries(netxduo)
endif()

if(${CONFIG_LEVELX})
    add_subdirectory(../../levelx level)
    link_libraries(levelx)
endif()

if(${CONFIG_FILEX})
    add_subdirectory(../../filex file)
    link_libraries(filex)
endif()

if(${CONFIG_GUIX})
    add_subdirectory(../../guix gui)
    link_libraries(guix)
endif()

add_subdirectory(../../threadx threadx)
link_libraries(threadx)

if(${CONFIG_MBEDTLS})
    include_directories(../../../mbedtls/include/mbedtls)
    include_directories(../../../mbedtls/include/psa)
    add_definitions(-DINCLUDE_MBEDTLS)
    set(ENABLE_TESTING          OFF           CACHE BOOL      "Enable Test")
    set(ENABLE_PROGRAMS          OFF           CACHE BOOL      "Enable programs")
    add_subdirectory(../../../mbedtls mbedtls)
    link_libraries(mbedtls mbedcrypto mbedx509)
endif()

# Tinycrypt
if(${CONFIG_TINYCRYPT})
    add_definitions(-DINCLUDE_TINYCRYPT)
    include_directories(../../../tinycrypt/lib/include)
    aux_source_directory(../../../tinycrypt/lib/source TINYCRYPT_SRC_LIST)
    add_library(tinycrypt STATIC ${TINYCRYPT_SRC_LIST})
    link_libraries(tinycrypt)
endif()

# Link target
if(${CONFIG_TX_SINGLE_MODE_SECURE})
set(LD_SCRIPT "thomas_m33.ld")
elseif(CONFIG_TX_SINGLE_MODE_NON_SECURE)
set(LD_SCRIPT "thomas_m33_ns.ld")
else()
message(FATAL_ERROR "Don't know run on secure or non-secure")
endif()

set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_HOME_DIRECTORY}/${LD_SCRIPT} \
    -Wl,-Map=linkmap.txt,--build-id=none -nostartfiles")

# Source
aux_source_directory(. SRC_LIST)
set(SRC_LIST
    ${SRC_LIST}
    cortexm33_crt0.S
    cortexm33_vectors.S
    )

# Fix build
set(SRC_LIST
    ${SRC_LIST}
    ${CMAKE_CURRENT_LIST_DIR}/../../threadx/ports/cortex_m33/gnu/src/tx_thread_secure_stack_initialize.S
    )

# Which Demo to build
set(DEMO_DIR ${CMAKE_CURRENT_LIST_DIR}/../demo)
if("${CONFIG_DEMO}" STREQUAL "threadx")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/threadx/sample_threadx.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "threadx-simple")
    add_definitions(-DSIMPLE_DEMO)
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/threadx/sample_threadx.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "netx")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/netx/demo_netx_udp.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "filex")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/filex/demo_filex.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "netxduo")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/netxduo/demo_netx_duo_udp.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "usbx")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/usbx/demo_usbx.c
        )
elseif("${CONFIG_DEMO}" STREQUAL "levelx")
    set(SRC_LIST
        ${SRC_LIST}
        ${DEMO_DIR}/demo_filex_nor_flash.c
        )
else()
    message(FATAL_ERROR "${CONFIG_DEMO} does not have reasonable demo to run")
endif()

# Target
add_executable(${TARGET}.elf "")

target_sources(${TARGET}.elf
    PRIVATE
    ${SRC_LIST}
)

add_custom_target(${TARGET}.bin ALL
    COMMAND ${OBJCOPY} -O binary ${TARGET}.elf ${TARGET}.bin
    COMMAND ${OBJDUMP} -xd ${TARGET}.elf > ${TARGET}.asm
    DEPENDS ${TARGET}.elf
)
