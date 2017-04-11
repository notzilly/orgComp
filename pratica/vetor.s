.text
    la   $t0, vetorA      # endereço base do vetorA
    lw   $t1, 0($t0)      # $t1 = vetorA[0]
    lw   $t2, 4($t0)      # $t2 = vetorA[1] considerando que cada posição utiliza 4 bytes
    add  $t3, $t1, $t2    # $t3 = $t1 + $t2
    sw   $t3, 8($t0)      # vetorA[2] = $t3

    li   $v0, 1           # syscall para imprimir inteiro pt. 1
    add  $a0, $t3, $zero  # syscall para imprimir inteiro pt. 2
    syscall               # syscall para imprimir inteiro pt. 3

.data
    vetorA: .word 2,2,2,2,2,2,2,2,2,2