.thumb
.align


.global ExpLoopStaff
.type ExpLoopStaff, %function
ExpLoopStaff:

@hook at 802C688 using anything but r2
@hooking at 802C694 overwrote the pop {r4} at 802C69A that the early returns
@branch to (enemies and max level units), so we do the halving here too
@r0 = nonzero if exp is halved
@r2 = current exp value (not capped)

push {r4-r7}
cmp r0,#0
beq NoHalve
lsr r0,r2,#31
add r0,r2,r0
asr r2,r0,#1
NoHalve:
cmp r2,#100
ble NoInitialCap
mov r2,#100
NoInitialCap:

mov r4,r2 @base exp value
ldr r5,=#0x203A4EC @attacker
ldr r6,=#0x203A56C @defender

ldr r7,=EXPCalcFunctions
LoopStart1:
ldr r3,[r7]
cmp r3, #0
beq LoopExit1
mov lr,r3

mov r0,r4
mov r1,r5
mov r2,r6
.short 0xF800
mov r4,r0

add r7,#4
b LoopStart1

LoopExit1:
mov r0,r4
cmp r0,#100
ble ApplyExp
mov r0,#100

ApplyExp:
pop {r4-r7}
pop {r4}
pop {r1}
bx r1

.ltorg
.align
