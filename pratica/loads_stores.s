.text
    .globl main
    main:
        la $s0, inteiro1

        lb $t0, 0($s0) # $t0 = memoria[$s0+0] // endereço base de $s0 + 0 byte

        lb $t1, 1($s0) # $t1 = memoria[$s0+1] // endereço base de $s0 + 1 byte


        # instruções unsigned (lhu, lbu etc) preenche com zeros os bytes da frente, caso
        # o valor que pegamos é menor que o espaço onde colocaremos

.data
    inteiro1: .byte 0x64 #100 em decimal
    inteiro2: .byte 0x64
