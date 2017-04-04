.text
    .globl main
    main:
        addiu $t0, $zero, 10 # $t0 = 10
        addiu $t1, $zero, 0x000F

        la $s0, varA # endereco de varA
        sw $t0, 0($s0) # varA = $t0 = 10

        la $s0, varB # endereço de varB
        
        sw $t1, 0($s0) # varB = $t1 = 1.000.000

.data 
    varA: .space 4 # 4 bytes
    varB: .space 4 