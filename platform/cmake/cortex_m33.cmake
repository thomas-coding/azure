# Name of the target
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m33)

set(THREADX_ARCH "cortex_m33")
set(THREADX_TOOLCHAIN "gnu")

set(MCPU_FLAGS "-mthumb -mcpu=cortex-m33")
set(VFP_FLAGS "")
set(SPEC_FLAGS "--specs=nosys.specs")
# set(LD_FLAGS "-nostartfiles")

# Mbedtls config
set(MBEDTLS_FLAGS "-DMBEDTLS_CONFIG_FILE='<user_mbedtls_config.h>'")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)