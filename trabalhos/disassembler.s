# Projeto: Desenvolver um programa disassembler (desmontador ou desassemblador) para o processador MIPS.

# O programa faz a leitura de um arquivo com o código em linguagem de máquina, processa e escreve o 
# correspondente arquivo em linguagem de montagem.

# A equipe (dupla) deve escrever, testar e documentar o programa. 

# Enviar via Moodle o relatório (em pdf) do projeto. Anexar o código documentado do programa.
# Enviar via Moodle o código do programa.

# Em anexo temos um código em linguagem de máquina que deve ser desmontado. O código inicia no
# endereço 0x00400000

.text
.globl    main
main:       
    addiu $sp, $sp, -8  # alocamos na pilha espaço para as variáveis
    # abertura do arquivo de leitura
    la    $a0, arquivoEntrada # $a0 <- endereço da string com o nome do arquivo
    li    $a1, 0 # flags: 0  - leitura
    li    $a2, 0 # modo - atualmente é ignorado pelo serviço
    #chamamos o serviço 13 para a abertura do arquivo
    li    $v0, 13   
    syscall   
    sw    $v0, 0($sp)   # gravamos o descritor do arquivo
    slt   $t0, $v0, $zero # verificamos se houve um erro na abertura do arquivo
    bne   $t0, $zero, erroAberturaArquivoLeitura

    j     verificaFinalArquivo

lacoLeiaPalavra:
    lw    $t0, 4($sp) # carrega instrução
    srl   $t0, $t0, 26 # pega os 6 MSB
    slti  $t2, $t0, 1 # verifica se opcode é 0
    bne   $t2, $zero, opCodeR # salta para trecho de instruções R
    
    # imprime mneumônico para instruções I e J
    sll   $t2, $t0, 4  # ajusta endereço pra pegar da tabela -> $t2 = $t0 * 16
    la    $t1, opcodeTable # tabela de opcode
    add   $t1, $t1, $t2 # $t1 = ender. base + deslocamento
    la    $a0, 0($t1) # printa mneumônico como string
    li    $v0, 4
    syscall

    # verifica se instrução é do tipo J
    li    $t3, 2
    beq   $t0, $t3, opCodeJ # if opcode = 02 
    li    $t3, 3
    beq   $t0, $t3, opCodeJ # ou = 03

opcodeI:
    # switch para instruções tipo I
    lw    $t0, 8($t1)  # pega tipo da instrução
    li    $t2, 1
    beq   $t0, $t2, I1  # tipo I1
    li    $t2, 2
    beq   $t0, $t2, I2  # tipo I2
    li    $t2, 3
    beq   $t0, $t2, I3  # tipo I3
    li    $t2, 4
    beq   $t0, $t2, I4  # tipo I4
    li    $t2, 5
    beq   $t0, $t2, I5  # tipo I5

I1:
    # RT, RS, immediate
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    li    $v0, 1 # printa registrador RT como inteiro
    syscall

    la    $a0, stringVirgula # imprimimos uma virgula, um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS como inteiro
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # IMMEDIATE
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000FFFF # carrega máscara
    and   $t0, $t0, $t2 # pega os 16 bits
    addi  $sp, $sp, -4 # ajusta pilha
    sh    $t0, 0($sp) # extendemos o sinal do immediate
    lh    $a0, 0($sp)
    addi  $sp, $sp, 4 # restaura pilha
    li    $v0, 1 # printa immediate como inteiro
    syscall
    
    j novaLinhaInstrucao # pula para novaLinhaInstrucao

I2:
    # RT, RS, offset
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador rt como inteiro
    syscall

    la    $a0, stringVirgula # imprimimos uma virgula, um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    li    $v0, 1 # printa registrador rs como inteiro
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # offset
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000FFFF # carrega máscara
    and   $a0, $t0, $t2 # pega os 16 bits
    li    $v0, 34 # printa offset
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

I3:
    # RT, offset(RS)
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    # printa registrador RT
    li    $v0, 1
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # offset
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000FFFF # carrega máscara
    and   $a0, $t0, $t2 # pega os 16 bits
    li    $v0, 34 # printa offset
    syscall

    la    $a0, stringAbrePar # imprimimos um abre par. e um cifrão
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS como inteiro
    syscall

    la    $a0, stringFechPar # imprimimos um fecha par.
    li    $v0, 4
    syscall
    
    j novaLinhaInstrucao # pula para novaLinhaInstrucao

I4:
    # RT, immediate
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    # printa registrador RT
    li    $v0, 1
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # IMMEDIATE
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000FFFF # carrega máscara
    and   $a0, $t0, $t2 # pega os 16 bits
    li    $v0, 34 # printa immediate como hex
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

I5:
    # RS, offset
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS como inteiro
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # offset
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000FFFF # carrega máscara
    and   $a0, $t0, $t2 # pega os 16 bits
    li    $v0, 34 # printa offset
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao
    
opCodeR:
    # OPCODE
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000003F # carrega máscara
    and   $t0, $t0, $t2 # pega os 6 bits menos significativos (funct)
    sll   $t0, $t0, 4  # ajusta endereço pra pegar da tabela -> $t0 = $t0 * 16
    la    $t1, functTable00 # tabela funct para opcode 000000
    add   $t1, $t1, $t0 # $t1 = ender. base + deslocamento
    la    $a0, 0($t1) # printa mneumônico
    li    $v0, 4
    syscall

    # switch para instruções tipo R
    lw    $t0, 8($t1)  # pega tipo da instrução
    li    $t2, 6
    beq   $t0, $t2, R1  # tipo R1
    li    $t2, 7
    beq   $t0, $t2, R2  # tipo R2
    li    $t2, 8
    beq   $t0, $t2, R3  # tipo R3
    li    $t2, 9
    beq   $t0, $t2, R4  # tipo R4
    li    $t2, 10
    beq   $t0, $t2, R5  # tipo R5
    li    $t2, 11
    beq   $t0, $t2, R6  # tipo R6

R1:
    # RD, RS, RT
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RD
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000F800 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 11 # shifta valor para a direita
    li    $v0, 1 # printa registrador RD como inteiro
    syscall

    la    $a0, stringVirgula # imprimimos uma virgula, um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS
    syscall

    la    $a0, stringVirgula # imprimimos uma virgula, um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    li    $v0, 1 # printa registrador RT
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

R2:
    # RD, RT, shift_amm
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RD
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000F800 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 11 # shifta valor para a direita
    li    $v0, 1 # printa registrador RD como inteiro
    syscall

    la    $a0, stringVirgula # imprimimos uma virgula, um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    li    $v0, 1 # printa registrador RT
    syscall

    la    $a0, stringVirEsp # imprimimos uma virgula e um espaço
    li    $v0, 4
    syscall

    # SHIFT AMMOUNT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x000007C0 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 6 # shifta valor para a direita
    li    $v0, 1 # printa shift ammount
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

R3:
    # RS
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

R4:
    # RS, RT
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RS
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03E00000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 21 # shifta valor para a direita
    li    $v0, 1 # printa registrador RS
    syscall

    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RT
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x001F0000 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 16 # shifta valor para a direita
    li    $v0, 1 # printa registrador RT
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

R5:
    # RD
    la    $a0, stringEspaco # imprimimos um espaço e um $
    li    $v0, 4
    syscall

    # RD
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x0000F800 # carrega máscara
    and   $t0, $t0, $t2 # pega os 5 bits
    srl   $a0, $t0, 11 # shifta valor para a direita
    li    $v0, 1 # printa registrador RD como inteiro
    syscall

    j novaLinhaInstrucao # pula para novaLinhaInstrucao

R6:
    # MNEUMÔNICO (já foi printado)
    j novaLinhaInstrucao # pula para novaLinhaInstrucao

opCodeJ:
    la    $a0, stringLabel # imprimimos um espaço
    li    $v0, 4
    syscall

    # LABEL
    lw    $t0, 4($sp) # carrega instrução
    li    $t2, 0x03FFFFFF # carrega máscara para pegar os 26 últimos bits
    and   $a0, $t0, $t2 # pega os 26 bits após o opcode
    sll   $a0, $a0, 2 # calcula endereço de salto
    li    $v0, 34 # printa endereço de salto
    syscall

novaLinhaInstrucao:
    li    $a0, '\n'
    li    $v0, 11
    syscall
    j     verificaFinalArquivo

verificaFinalArquivo:
    # lemos uma palavra do arquivo
    lw    $a0, 0($sp)   # $a0 <- descritor do arquivo
    addiu $a1, $sp, 4   # $a1 <- endereço do buffer de entrada 
    li    $a2, 4        # $a2 <- número de caracteres lidos
    li    $v0, 14
    syscall
    # verificamos se foram lidos 4 bytes
    slti  $t0, $v0, 4
    beq   $t0, $zero, lacoLeiaPalavra
    # terminamos o programa
    addiu $sp, $sp, 8 # restaura pilha
    li    $a0, 0 # 0 <- programa terminou de forma normal
    li    $v0, 17 # serviço exit2 - termina o programa
    syscall
        
erroAberturaArquivoLeitura:
    la    $a0, mensagemErroAberturaArquivo # $a0 <- endereço da string com mensagem de erro
    li    $v0, 4        # serviço 4: impressão de string
    syscall             # fazemos uma chamada ao sistema: fazemos a impressão da string, indicando o erro.
    li    $a0, 1 # valor diferente de 0: o programa terminou com erros
    li    $v0, 17 #serviço exit2 - termina o programa   
    syscall
                     
.data
stringVirgula: .asciiz ", $"
stringEspaco:  .asciiz " $"
stringVirEsp:  .asciiz ", "
stringLabel:   .asciiz " "
stringAbrePar: .asciiz "($"
stringFechPar: .asciiz ")"
arquivoEntrada: # nome do arquivo de entrada
.asciiz   "trabalhos/projeto_01_codigo.bin" 
mensagemErroAberturaArquivo: # mensagem de erro se o arquivo não pode ser aberto
.asciiz   "Erro na abertura do arquivo de entrada\n"
opcodeTable:  # cada instrução + tipo ocupam 16 bytes
# 0 - J - pseudo-address
# 1 - I1 - rt, rs, imm
# 2 - I2 - rt, rs, offset
# 3 - I3 - rt, offset($rs)
# 4 - I4 - rt, imm
# 5 - I5 - rs, offset
# 6 - R1 - rd, rs, rt
# 7 - R2 - rd, rt, shift_amm
# 8 - R3 - rs
# 9 - R4 - rs, rt
# 10 - R5 - rd
# 11 - R6 - somente mneumonico
.align    2
.space    16        # 00 - function table
.align    2
.space    16        # 01
.align    2
.asciiz   "j   "    # 02 - J
.align    2
.word     0
.space    4
.align    2
.asciiz   "jal "    # 03 - J
.align    2
.word     0
.space    4
.align    2
.asciiz   "beq "    # 04 - I2
.align    2
.word     2
.space    4
.align    2
.asciiz   "bne "    # 05 - I2
.align    2
.word     2
.space    4
.align    2
.asciiz   "blez"    # 06 - I5
.align    2
.word     5
.space    4
.align    2
.asciiz   "bgtz"    # 07 - I5
.align    2
.word     5
.space    4
.align    2
.asciiz   "addi"    # 08 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "addiu"   # 09 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "slti"    # 10 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "slitu"   # 11 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "andi"    # 12 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "ori "    # 13 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "xori"    # 14 - I1
.align    2
.word     1
.space    4
.align    2
.asciiz   "lui "    # 15 - I4
.align    2
.word     4
.space    4
.align    2
.space    16        # 16
.align    2
.space    16        # 17
.align    2
.space    16        # 16
.align    2
.space    16        # 19
.align    2
.space    16        # 20
.align    2
.space    16        # 21
.align    2
.space    16        # 22
.align    2
.space    16        # 23
.align    2
.space    16        # 24
.align    2
.space    16        # 25
.align    2
.space    16        # 26
.align    2
.space    16        # 27
.align    2
.space    16        # 28
.align    2
.space    16        # 29
.align    2
.space    16        # 30
.align    2
.space    16        # 31
.align    2
.asciiz   "lb  "    # 32 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lh  "    # 33 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lwl "    # 34 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lw  "    # 35 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lbu "    # 36 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lhu "    # 37 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "lwr "    # 38 - I3
.align    2
.word     3
.space    4
.align    2
.space    16        # 39
.align    2
.asciiz   "sb  "    # 40 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "sh  "    # 41 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "swl "    # 42 - I3
.align    2
.word     3
.space    4
.align    2
.asciiz   "sw  "    # 43 - I3
.align    2
.word     3
.space    4
.align    2
.space    16        # 44 
.align    2
.space    16        # 45
.align    2
.asciiz   "swr "    # 46 - I3
.align    2
.word     3
.space    4
.align    2
functTable00:
.asciiz   "sll "    # 00 - R2
.align    2
.word     7
.space    4
.align    2
.space    16        # 01
.align    2
.asciiz   "srl "    # 02 - R2
.align    2
.word     7
.space    4
.align    2
.asciiz   "sra "    # 03 - R2
.align    2
.word     7
.space    4
.align    2
.asciiz   "sllv"    # 04 - R1
.align    2
.word     6
.space    4
.align    2
.space    16        # 05
.align    2
.asciiz   "srlv"    # 06 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "srav"    # 07 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "jr  "    # 08 - R3
.align    2
.word     8
.space    4
.align    2
.asciiz   "jalr"    # 09 - R3
.align    2
.word     8
.space    4
.align    2
.asciiz   "movz"    # 10 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "movn"    # 11 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "syscall" # 12 - R6
.align    2
.word     11
.space    4
.align    2
.space    16        # 13
.align    2
.space    16        # 14
.align    2
.space    16        # 15
.align    2
.asciiz   "mfhi"    # 16 - R5
.align    2
.word     10
.space    4
.align    2
.asciiz   "mthi"    # 17 - R5
.align    2
.word     10
.space    4
.align    2
.asciiz   "mflo"    # 18 - R5
.align    2
.word     10
.space    4
.align    2
.asciiz   "mtlo"    # 19 - R5
.align    2
.word     10
.space    4
.align    2
.space    16        # 20
.align    2
.space    16        # 21
.align    2
.space    16        # 22
.align    2
.space    16        # 23
.align    2
.asciiz   "mult"    # 24 - R4
.align    2
.word     9
.space    4
.align    2
.asciiz   "multu"   # 25 - R4
.align    2
.word     9
.space    4
.align    2
.asciiz   "div "    # 26 - R4
.align    2
.word     9
.space    4
.align    2
.asciiz   "divu"    # 27 - R4
.align    2
.word     9
.space    4
.align    2
.space    16        # 28
.align    2
.space    16        # 29
.align    2
.space    16        # 30
.align    2
.space    16        # 31
.align    2
.asciiz   "add "    # 32 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "addu"    # 33 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "sub "    # 34 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "subu"    # 35 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "and "    # 36 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "or  "    # 37 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "xor "    # 38 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "nor "    # 39 - R1
.align    2
.word     6
.space    4
.align    2
.space    16        # 40
.align    2
.space    16        # 41
.align    2
.asciiz   "slt "    # 42 - R1
.align    2
.word     6
.space    4
.align    2
.asciiz   "sltu"    # 43 - R1
.align    2
.word     6
.space    4
.align    2