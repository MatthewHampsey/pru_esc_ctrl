
;***************************************************************
;* FNAME: pwm4                          FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************
  .global pwm4
||pwm4||:
;* --------------------------------------------------------------------------*
;* r0_0  assigned to $O$C3
;* r23_0 assigned to $O$L1
;* r14_0 assigned to pinA
;* r15_0 assigned to cyclesA
;* r16_0 assigned to pinB
;* r17_0 assigned to cyclesB
;* r18_0 assigned to pinC
;* r19_0 assigned to cyclesC
;* r20_0 assigned to pinD
;* r21_0 assigned to cyclesD
;* r22_0 assigned to period
;* r0_0  assigned to out
;* r1_0  assigned to cycle_count

        MAX       r0, r15, r17          ; [ALU_PRU] |109| cyclesA,cyclesB
        MAX       r0, r0, r19           ; [ALU_PRU] |109| cyclesC
        MAX       r0, r0, r21           ; [ALU_PRU] |109| $O$C3,cyclesD
        ZERO      &r1, 4                ; [ALU_PRU] |109| cycle_count
        QBEQ      ||$C$L10||, r0, 0x00   ; [ALU_PRU] |109| $O$C3
;* --------------------------------------------------------------------------*
        MOV       r23, r0               ; [ALU_PRU] |112| $O$L1,$O$C3
;* --------------------------------------------------------------------------*
||$C$L1||:    
        ADD       r1, r1, 0x000E            ;                   //preempt no. cycles to set. 14 cycles til we set R30
        QBGE      ||$C$L2||, r15, r1    ; [ALU_PRU] |112| cycle_count,cyclesA      if cycle_count(r1) >= cyclesA(r15) goto CL2
;* --------------------------------------------------------------------------*
        MOV       r0, r14               ; [ALU_PRU] |114| out,pinA                 r0 = pinA
        JMP       ||$C$L3||
;* --------------------------------------------------------------------------*
||$C$L2||:
        ZERO      &r0, 4
        NOP    
||$C$L3||:
        QBGE      ||$C$L4||, r17, r1    ; [ALU_PRU] |117| cycle_count,cyclesB
;* --------------------------------------------------------------------------*
        OR        r0, r0, r16           ; [ALU_PRU] |119| out,out,pinB
        JMP       ||$C$L5||
;* --------------------------------------------------------------------------*
||$C$L4||:
        NOP
	NOP

||$C$L5||:
        QBGE      ||$C$L6||, r19, r1    ; [ALU_PRU] |122| cycle_count,cyclesC
;* --------------------------------------------------------------------------*
        OR        r0, r0, r18           ; [ALU_PRU] |124| out,out,pinC
        JMP       ||$C$L7||
;* --------------------------------------------------------------------------*
||$C$L6||:
        NOP
        NOP    
||$C$L7||:
        QBGE      ||$C$L8||, r21, r1    ; [ALU_PRU] |127| cycle_count,cyclesD
;* --------------------------------------------------------------------------*
        OR        r0, r0, r20           ; [ALU_PRU] |129| out,out,pinD
        JMP       ||$C$L9||
;* --------------------------------------------------------------------------*
||$C$L8||:
        NOP
        NOP

||$C$L9||:
        MOV       r30, r0               ; [ALU_PRU] |131| out

        ADD       r1, r1, 2          ; [ALU_PRU] |109| cycle_count,cycle_count     2 instr including next branch
        QBLT      ||$C$L1||, r23, r1  ; [ALU_PRU] |109| $O$L1                      check if cycle_count > max_cycles
;* --------------------------------------------------------------------------*
||$C$L10||:    
        ZERO      &r30, 4               ; [ALU_PRU] |133| 
        
        ADD       r1, r1, 2 
||$C$L11||:    
        ADD       r1, r1, 2
        QBGT      ||$C$L11||, r1, r22

        JMP       r3.w2                 ; [ALU_PRU] 
