.text
    main:
        # Carrega x para $s0
        la $t0, x
        lb $s0, 0($t0)

        # Desloca 2 bits para a esquerda (multiplica por 4)
        sll $s0, $s0, 2

        # Printa resultado que está em $a0
        add $a0, $s0, $zero
        li $v0, 1
        syscall
.data
    x: .byte 16