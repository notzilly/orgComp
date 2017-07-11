# Escreva um programa, em linguagem de montagem para o processador MIPS,
# que realiza a divisão de dois números em ponto inteiro de 32 bits. A
# divisão deve ser realizada com o segundo algoritmo da divisão do livro
# do Patterson (figura3.12), com somas e deslocamentos. Não utilize
# instruções em ponto flutuante. Teste o programa fazendo a divisão de 253 893 217 / 789.

# BLE e SLTU

.data
    dividendo: .word 253893217
    divisor:   .word 789
    quociente: .word 0
    resto:     .word 0

.text
.globl    main
main:
    addiu $sp, $sp, -16 # ajusta pilha para variáveis

    la    $t0, dividendo 
    lw    $t0, 0($t0) # t0 = dividendo
    la    $t1, divisor 
    lw    $t1, 0($t1) # t1 = divisor

    # inicializa valor do RESTO (65 bits)
    sb    $zero, 12($sp) # RESTO_EXT = 0
    sw    $zero, 0($sp) # RESTO_H = {000...0}
    sw    $t0, 4($sp) # RESTO_L = dividendo

    # inicializa valor do DIVISOR (33 bits)
    sb    $zero, 13($sp) # DIVISOR_EXT = 0
    sw    $t1, 8($sp) # DIVISOR = divisor

    jal   shifta_resto

    add   $s0, $zero, $zero # i = 0 
    j     while

shifta_resto:
    lw    $t0, 0($sp) # carrega RESTO_H
    sll   $t0, $t0, 1 # shifta RESTO_H

    lw    $t1, 4($sp) # carrega RESTO_L
    add   $t2, $zero, $zero # zera $t2
    slt   $t2, $t1, $zero # seta $t2 se RESTO_L for menor que zero
    sll   $t1, $t1, 1 # shifta RESTO_L

    or    $t0, $t0, $t2 # passa o bit de RESTO_L para RESTO_H

incrementa_while:
    
    

    addi  $s0, $s0, 1 # i = i + 1

while:
    addi  $t0, $zero, 33 # $t0 = 33 (total de iterações = n + 1)
    bne   $s0, $t0, incrementa_while # se $s0 != $t0 repete o loop

    li  $v0, 17 # serviço 17 - exit 2
    li  $a0, 0 # retorno do programa é 0 (sucesso)
    syscall # syscall



    #li    $a0, '\n'
    #li    $v0, 11
    #syscall

    #li $v0, 1
    #add $a0, $s0, $zero
    #syscall