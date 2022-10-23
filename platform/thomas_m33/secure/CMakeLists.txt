cmake_minimum_required(VERSION 3.0.0)

# Set up the project
project(thomas_m33_s
    LANGUAGES C ASM
)

set(TARGET "thomas_m33_s")
enable_language( C ASM )

# Include
include_directories(.)
include_directories(./sau)

# Link target
set(LD_SCRIPT "thomas_m33_s.ld")
set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_HOME_DIRECTORY}/${LD_SCRIPT} \
    -Wl,-Map=linkmap.txt,--build-id=none -nostartfiles")

# Source
aux_source_directory(. SRC_LIST)
set(SRC_LIST
    ${SRC_LIST}
    cortexm33_vectors_s.S
    cortexm33_crt0_s.S
    nsc.S
    sau/sau.c
    )

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
