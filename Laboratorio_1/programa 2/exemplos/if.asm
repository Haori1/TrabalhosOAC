.data

espaco: .string "               "
#Fazer:

#if (j > k) 
# j = j - k
#else
# k = k - j

.text

#s0 = j, s1 = k

#addi s0, zero, 12
#addi s1, zero, 21
li s0, 12	# k
li s1, 21	# j

bge s0, s1, else

sub s0, s0, s1
jal zero, continua
#bge s0, s1, continua

else:

sub s1, s1, s0

continua:

li a7, 1
mv a0, s1
ecall

la t0, espaco
li a7, 4
mv a0, t0
ecall

addi a7, zero, 1
add a0, zero, s0
ecall
