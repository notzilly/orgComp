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
    addiu $sp, $sp, 12  # alocamos na pilha espaço para as variáveis
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
    #  fazemos um contador igual a 8
    li    $t0, 8
    sw    $t0, 8($sp)
    # enquanto não chegamos no final do arquivo executamos o laço lacoLeiaPalavra
    j     verificaFinalArquivo            
lacoLeiaPalavra:
    # imprimimos a palavra se a leitura foi correta
    #lw    $a0, 4($sp)   # tomamos a palavra do buffer
    #li    $v0, 35       # serviço 34: imprime um inteiro em hexadecimal 
    #syscall

    # pega os 6 bits mais significativos (opcode)
    lw    $t0, 4($sp)
    srl   $t0, $t0, 26
    # verifica se opcode é 0
    slti  $t2, $t0, 1
    bne   $t2, $zero, opCodeZero
    # trecho de instruções I e J
    # ajusta endereço pra pegar da tabela
    sll   $t0, $t0, 3  # $t0 = $t0 * 8
    # tabela de opcode
    la    $t1, opcodeTable
    add   $t1, $t1, $t0 # $t1 = ender. base + deslocamento
    # printa opcode convertido
    la    $a0, 0($t1)
    li    $v0, 4
    syscall

    # imprimimos um espaço e um $
    la    $a0, stringEspaco
    li    $v0, 4
    syscall

    # RS
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x001F0000
    # pega os 5 bits após o opcode
    and   $t0, $t0, $t2
    srl   $a0, $t0, 16   #shifta valor para a direita
    # printa registrador rs
    li    $v0, 1
    syscall

    # imprimimos uma virgula, um espaço e um $
    la    $a0, stringVirgula
    li    $v0, 4
    syscall

    # RT
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x03E00000
    # pega os 5 bits após o rs
    and   $t0, $t0, $t2
    srl   $a0, $t0, 21   #shifta valor para a direita
    # printa registrador rt
    li    $v0, 1
    syscall

    # imprimimos uma virgula, um espaço e um $
    la    $a0, stringVirgula
    li    $v0, 4
    syscall

    # IMMEDIATE
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x0000FFFF
    # pega os 16 bits após o rt (immediate)
    and   $a0, $t0, $t2
    # printa immediate
    li    $v0, 34
    syscall   

    # pula para decrementaContador
    j decrementaContador

opCodeZero:
    # trecho para instruções do tipo R
    # OPCODE
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x0000003F
    # pega os 6 bits menos significativos (funct)
    and   $t0, $t0, $t2
    # ajusta endereço pra pegar da tabela
    sll   $t0, $t0, 3  # $t0 = $t0 * 8
    # tabela funct para opcode 000000
    la    $t1, functTable00
    add   $t1, $t1, $t0 # $t1 = ender. base + deslocamento
    # printa nome da instrução
    la    $a0, 0($t1)
    li    $v0, 4
    syscall

    # imprimimos um espaço e um $
    la    $a0, stringEspaco
    li    $v0, 4
    syscall

    # RS
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x0000F800
    # pega os 5 bits após o opcode
    and   $t0, $t0, $t2
    srl   $a0, $t0, 11   #shifta valor para a direita
    # printa registrador rs
    li    $v0, 1
    syscall

    # imprimimos uma virgula, um espaço e um $
    la    $a0, stringVirgula
    li    $v0, 4
    syscall

    # RT
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x03E00000
    # pega os 5 bits após o rs
    and   $t0, $t0, $t2
    srl   $a0, $t0, 21   #shifta valor para a direita
    # printa registrador rt
    li    $v0, 1
    syscall

    # imprimimos uma virgula, um espaço e um $
    la    $a0, stringVirgula
    li    $v0, 4
    syscall

    # RD
    # carrega instrução
    lw    $t0, 4($sp)
    # carrega máscara
    li    $t2, 0x001F0000
    # pega os 5 bits após o rt
    and   $t0, $t0, $t2
    srl   $a0, $t0, 16   #shifta valor para a direita
    # printa registrador rd
    li    $v0, 1
    syscall

decrementaContador:
    # decrementamos o contador
    lw    $t0, 8($sp)
    addiu $t0, $t0, -1
    sw    $t0, 8($sp)
    # se contador=0 (imprimimos 8 palavras) gera uma nova linha
    bne   $t0, $zero, imprimeEspaco
    # faz contador igual a 8
    li    $t0, 8
    sw    $t0, 8($sp)
    li    $a0, '\n'
    li    $v0, 11
    syscall
    j     verificaFinalArquivo

imprimeEspaco:
    # imprimimos um espaço
    li    $a0,' '
    li    $v0, 11
    syscall

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
arquivoEntrada: # nome do arquivo de entrada
.asciiz   "trabalhos/projeto_01_codigo.bin" 
mensagemErroAberturaArquivo: # mensagem de erro se o arquivo não pode ser aberto
.asciiz   "Erro na abertura do arquivo de entrada\n"
opcodeTable:
.align    2
.space    8         # 00
.align    2
.space    8         # 01
.align    2
.asciiz   "j   "    # 02
.align    2
.asciiz   "jal "    # 03
.align    2
.asciiz   "beq "    # 04
.align    2
.asciiz   "bne "    # 05
.align    2
.asciiz   "blez"    # 06
.align    2
.asciiz   "bgtz"    # 07
.align    2
.asciiz   "addi"    # 08
.align    2
.asciiz   "addiu"   # 09
.align    2
.asciiz   "slti"    # 10
.align    2
.asciiz   "sltiu"   # 11
.align    2
.asciiz   "andi"    # 12
.align    2
.asciiz   "ori "    # 13
.align    2
.asciiz   "xori"    # 14
.align    2
.asciiz   "lui "    # 15
.align    2
.space    8         # 16
.align    2
.space    8         # 17
.align    2
.space    8         # 18
.align    2
.space    8         # 19
.align    2
.asciiz   "beql"    # 20
.align    2
.asciiz   "bnel"    # 21
.align    2
.asciiz   "blezl"   # 22
.align    2
.asciiz   "bgtzl"   # 23
.align    2
.space    8         # 24
.align    2
.space    8         # 25
.align    2
.space    8         # 26
.align    2
.space    8         # 27
.align    2
.space    8         # 28
.align    2
.space    8         # 29
.align    2
.space    8         # 30
.align    2
.space    8         # 31
.align    2
.asciiz   "lb  "    # 32
.align    2
.asciiz   "lh  "    # 33
.align    2
.asciiz   "lwl "    # 34
.align    2
.asciiz   "lw  "    # 35
.align    2
.asciiz   "lbu "    # 36
.align    2
.asciiz   "lhu "    # 37
.align    2
.asciiz   "lwr "    # 38
.align    2
.space    8         # 39
.align    2
.asciiz   "sb  "    # 40
.align    2
.asciiz   "sh  "    # 41
.align    2
.asciiz   "swl "    # 42
.align    2
.asciiz   "sw  "    # 43
.align    2
.space    8         # 44
.align    2
.space    8         # 45
.align    2
.asciiz   "swr "    # 46
.align    2
.asciiz   "cache"   # 47
.align    2
functTable00:
.align    2
.asciiz   "sll "    # 00
.align    2
.space    8         # 01
.align    2
.asciiz   "srl "    # 02
.align    2
.asciiz   "sra "    # 03
.align    2
.asciiz   "sllv"    # 04
.align    2
.space    8         # 05
.align    2
.asciiz   "srlv"    # 06
.align    2
.asciiz   "srav"    # 07
.align    2
.asciiz   "jr  "    # 08
.align    2
.asciiz   "jalr"    # 09
.align    2
.asciiz   "movz"    # 10
.align    2
.asciiz   "movn"    # 11
.align    2
.asciiz   "syscall" # 12
.align    2
.asciiz   "break"   # 13
.align    2
.space    8         # 14
.align    2
.asciiz   "sync"    # 15
.align    2
.asciiz   "mfhi"    # 16
.align    2
.asciiz   "mthi"    # 17
.align    2
.asciiz   "mflo"    # 18
.align    2
.asciiz   "mtlo"    # 19
.align    2
.space    8         # 20
.align    2
.space    8         # 21
.align    2
.space    8         # 22
.align    2
.space    8         # 23
.align    2
.asciiz   "mult"    # 24
.align    2
.asciiz   "multu"   # 25
.align    2
.asciiz   "div "    # 26
.align    2
.asciiz   "divu"    # 27
.align    2
.space    8         # 28
.align    2
.space    8         # 29
.align    2
.space    8         # 30
.align    2
.space    8         # 31
.align    2
.asciiz   "add "    # 32
.align    2
.asciiz   "addu"    # 33
.align    2
.asciiz   "sub "    # 34
.align    2
.asciiz   "subu"    # 35
.align    2
.asciiz   "and "    # 36
.align    2
.asciiz   "or  "    # 37
.align    2
.asciiz   "xor "    # 38
.align    2
.asciiz   "nor "    # 39
.align    2
.space    8         # 40
.align    2
.space    8         # 41
.align    2
.asciiz   "slt "    # 42
.align    2