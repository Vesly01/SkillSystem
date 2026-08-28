.thumb
.align

@ Save/load gCharPalOverride 

.global MSa_WriteCharPalOverride
.type MSa_WriteCharPalOverride, %function

.global MSa_ReadCharPalOverride
.type MSa_ReadCharPalOverride, %function

.equ WriteAndVerifySramFast, 0x080D184C+1
.equ ReadSramFastAddr, 0x030067A0   @ pointer to the actual ReadSramFast function

.equ gCharPalOverride, 0x020287C0


@ r0 = SRAM chunk address (destination), r1 = size, on entry (per chunk saver convention)
MSa_WriteCharPalOverride:
push {r14}

mov r2, r1                  @ WriteAndVerifySramFast arg r2 = size
mov r1, r0                  @ WriteAndVerifySramFast arg r1 = dest SRAM address
ldr r0, =gCharPalOverride    @ WriteAndVerifySramFast arg r0 = source RAM pointer

ldr r3, =WriteAndVerifySramFast
mov r14, r3
.short 0xF800

pop {r0}
bx r0

.ltorg
.align


@ r0 = SRAM chunk address (source), r1 = size, on entry (per chunk loader convention)
MSa_ReadCharPalOverride:
push {r14}

mov r2, r1                  @ ReadSramFast arg r2 = size
ldr r1, =gCharPalOverride    @ ReadSramFast arg r1 = dest RAM pointer
@ r0 already holds the SRAM source address (unchanged since entry) - ReadSramFast arg r0

ldr r3, =ReadSramFastAddr
ldr r3, [r3]                 @ r3 = ReadSramFast
mov r14, r3
.short 0xF800

pop {r0}
bx r0

.ltorg
.align
