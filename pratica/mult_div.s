.text
    la $t0, x
    lb $t1, 0($t0)
    la $t0, y
    lb $t2, 0($t0)

    mult $t1, $t2        # Multiplica 100 * 20

    mfhi $t3
    mflo $a0

    li $v0, 1            # Printa resultado que está em $a0
    syscall

    div $t1, $t2         # Divide 100 / 20

    mfhi $t3
    mflo $a0

    li $v0, 1            # Printa resultado que está em $a0
    syscall

.data
    x: .byte 100
    y: .byte 20