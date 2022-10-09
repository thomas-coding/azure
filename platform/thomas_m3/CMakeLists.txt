cmake_minimum_required(VERSION 3.10)

project(thomas_m3)

#add_subdirectory(${CMAKE_HOME_DIRECTORY}/../threadx)

#toolchain
set(CROSS_COMPILE $ENV{CROSS_COMPILE})
set(CMAKE_C_COMPILER ${CROSS_COMPILE}gcc)
set(CMAKE_CXX_COMPILER ${CROSS_COMIPLE}g++)
set(CMAKE_LD ${CROSS_COMPILE}ld)


# Define linker and target
set(LD_SCRIPT "thomas_m3.ld")
set(Target "thomas_m3")

#compile option
set(CMAKE_C_FLAGS "-g -nostartfiles -mthumb -mcpu=cortex-m3")

#link
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS)
set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_HOME_DIRECTORY}/${LD_SCRIPT} \
-Wl,-Map=linkmap.txt,--build-id=none -nostartfiles -specs=nosys.specs ")

#include
include_directories(.)

#common source
aux_source_directory(. SRC_LIST)

set(SRC_LIST
    ${SRC_LIST}
    cortexm3_crt0.S
    cortexm3_vectors.S
    tx_initialize_low_level.S
    )

set_property(
    SOURCE cortexm3_crt0.S
    SOURCE cortexm3_vectors.S
    SOURCE tx_initialize_low_level.S
    PROPERTY LANGUAGE C
)

# link threadx
include_directories(../../threadx/common/inc)
include_directories(../../threadx/ports/cortex_m3/gnu/inc)
link_directories(../../threadx/build)
link_libraries(threadx)
#add_subdirectory(../../threadx build)

link_libraries(m)
add_executable(${Target}.elf "")

#target
target_sources(${Target}.elf
    PRIVATE
    ${SRC_LIST}
)

add_custom_target(${Target}.bin ALL
    COMMAND ${CROSS_COMPILE}objcopy -O binary ${Target}.elf ${Target}.bin
    COMMAND ${CROSS_COMPILE}objdump -xd ${Target}.elf > ${Target}.asm
    DEPENDS ${Target}.elf
)
