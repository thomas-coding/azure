  .global reset_handler

  .global __tx_NMIHandler
  .global __tx_BadHandler
  .global SVC_Handler
  .global __tx_DBGHandler
  .global PendSV_Handler 
  .global __tx_SysTickHandler 
  .global __tx_BadHandler

  .syntax unified
  .section .vectors, "ax"
  .code 16
  .align 0
  .global _vectors

_vectors:
  .word __stack_end__ 
  .word reset_handler 
  .word __tx_NMIHandler 
  .word HardFault_Handler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word 0 // Reserved
  .word 0 // Reserved
  .word 0 // Reserved
  .word 0 // Reserved
#if defined(TX_SINGLE_MODE_SECURE) || defined(TX_SINGLE_MODE_NON_SECURE)
  .word 0 // Reserved
#else
  .word SVC_Handler
#endif
  .word __tx_DBGHandler
  .word 0 // Reserved
  .word PendSV_Handler 
  .word SysTick_Handler   // Used by Threadx timer functionality
  .word __tx_BadHandler       // Populate with user Interrupt handler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler
  .word __tx_BadHandler

  .section .init, "ax"
  .thumb_func
reset_handler:
  // low level hardware config, such as PLL setup goes here
  b _start



