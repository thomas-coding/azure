cmake_minimum_required(VERSION 3.0.0)

# Set up the project
project(thomas_m3
    LANGUAGES C ASM
)

set(TARGET "thomas_m3")
enable_language( C ASM )

include(config.cmake)

# Define ThreadX user configuration
set(TX_USER_FILE "${CMAKE_CURRENT_LIST_DIR}/tx_user.h" CACHE STRING "Enable TX user configuration")

# Include
include_directories(.)
include_directories(../../threadx/common/inc)
include_directories(../../threadx/ports/cortex_m3/gnu/inc)
include_directories(../../filex/common/inc)
include_directories(../../filex/ports/cortex_m3/gnu/inc)

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

# Link target
set(LD_SCRIPT "thomas_m3.ld")
set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_HOME_DIRECTORY}/${LD_SCRIPT} \
    -Wl,-Map=linkmap.txt,--build-id=none -nostartfiles")

# Source
aux_source_directory(. SRC_LIST)
set(SRC_LIST
    ${SRC_LIST}
    cortexm3_crt0.S
    cortexm3_vectors.S
    tx_initialize_low_level.S)

# Which Demo to build
set(DEMO_DIR ${CMAKE_CURRENT_LIST_DIR}/../demo)
if("${CONFIG_DEMO}" STREQUAL "threadx")
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
