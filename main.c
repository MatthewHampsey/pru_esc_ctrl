#include "resource_table_0.h"
#include <pru_cfg.h>

volatile register uint32_t __R30; //R30 is output reg

typedef struct
{
  uint32_t A;
  uint32_t B;
  uint32_t C;
  uint32_t D;
  uint32_t period;
} DutyCycles;

volatile __far DutyCycles duty_cycles  __attribute__((cregister("PRU_DMEM_0_1", near)))= {
	  .A =      200000,
	  .B =      200000, 
	  .C =      200000, 
	  .D =      200000, 
	  .period = 4000000
  };

extern void pwm4(uint32_t pinA, uint32_t cyclesA,
	              uint32_t pinB, uint32_t cyclesB,
	              uint32_t pinC, uint32_t cyclesC,
	              uint32_t pinD, uint32_t cyclesD,
		      uint32_t period);  //<--core loop is 16 cycles = 80ns worst case 

void main(void)
{
  CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

  while(1)
  {

    DutyCycles params = duty_cycles;
    pwm4(0x00000001, params.A,
	 0x00000002, params.B,
	 0x00000004, params.C,
	 0x00000008, params.D,
	 params.period);
  }
}
