.text
    main:
        # Atualiza stack pointer
        addiu $sp, $sp, -8

        # Guarda o valor das vars estáticas em $t0
        la $t0, vars
        # Guarda em $t1 o valor de $t0[0]
        lw $t1, 0($t0)
        # Guarda em $t2 em $t0[1]
        lw $t2, 4($t0)

        # Guarda $t1 e $t2 na pilha
        sw $t1, 0($sp)
        sw $t2, 4($sp)

        # Chama função da media
        jal media
         # Chama função que imprime
        jal imprime

        #Restaura pilha
        addiu $sp, $sp, 8

        # Sai do programa
        li $v0, 10
        syscall
        
    imprime:
        # Printa $s0
        li $v0, 1
        add $a0, $s0, $zero
        syscall

        # Restaura pilha $sp (não necessário nesse caso)
        # Volta para main
        jr $ra

    media:
        # Atualiza stack pointer
        addiu $sp, $sp, -4

        # Guarda a soma de A e B em $s0
        add $s0, $t1, $t2
        # Guarda em $t3 o número 2 para fazer a divisão
        addi $t3, $zero, 2
        # Divide $s0 por $t3
        div $s0, $t3
        # Guarda em $s0 o quociente da divisão
        mflo $s0

        # Guarda na pilha o resultado
        sw $s0, 0($sp)

        # Restaura pilha $sp
        addiu $sp, $sp, 4
        # Volta para main
        jr $ra

.data
    vars: .word 0x24cea288, 0x0001d89
