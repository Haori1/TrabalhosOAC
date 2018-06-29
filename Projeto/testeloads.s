.eqv BITMAP_ADDRESS 0xFF000000
.data

datateste: .byte 0x12, 0x34, 0x56, 0x78
datateste2: .byte 0x12, 0x43, 0x65, 0x87, 0x9a, 0x9b, 0x9c, 0x10

.text

la t0, datateste
lw t1, 0(t0)
lb t2, 0(t0)
lb t3, 1(t0)
lb t4, 2(t0)
lb t5, 3(t0)

li t2, 0xAA
sb t2, 0(t0)

la t0, datateste
la t1, datateste2
lb t2, 4(t1)


out: