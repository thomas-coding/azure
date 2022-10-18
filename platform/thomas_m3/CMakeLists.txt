cmake_minimum_required(VERSION 3.0.0)

# Set up the project
project(thomas_m3
    LANGUAGES C ASM
)

set(TARGET "thomas_m3")
enable_language( C ASM )

# Define ThreadX user configuration
set(TX_USER_FILE "${CMAKE_CURRENT_LIST_DIR}/tx_user.h" CACHE STRING "Enable TX user configuration")

# Include
include_directories(.)
include_directories(../../threadx/common/inc)
include_directories(../../threadx/ports/cortex_m3/gnu/inc)
include_directories(../../filex/common/inc)
include_directories(../../filex/ports/cortex_m3/gnu/inc)

# Add azure kernel and x
add_subdirectory(../../usbx usb)
add_subdirectory(../../netxduo net)
add_subdirectory(../../levelx level)
add_subdirectory(../../filex file)
add_subdirectory(../../guix gui)
add_subdirectory(../../threadx kernel)

# Link libthreadx.a
link_libraries(usbx netxduo levelx filex guix threadx)

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
