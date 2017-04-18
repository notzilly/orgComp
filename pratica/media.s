.text
    main:
        # Guarda o valor da var A em $t1
        la $t0, avar
        lw $t1, 0($t0)
        # Guarda o valor da var B em $t2
        la $t0, bvar
        lw $t2, 0($t0)
        # Guarda a soma de A e B em $s0
        add $s0, $t1, $t2
        # Guarda em $t3 o número 2 para fazer a divisão
        addi $t3, $zero, 2
        # Divide $s0 por $t3
        div $s0, $t3
        # Guarda em $s0 o quociente da divisão
        mflo $s0
        # Printa $s0
        li $v0, 1
        add $a0, $s0, $zero
        syscall

.data
    avar: .word 0x24cea288
    bvar: .word 0x0001d89b