# UFSM - CT - GMICRO
# Autor: Giovani Baratto (giovani.baratto@ufsm.br)
# Data: 02/06/2017
# Descrição: Este programa faz a leitura de um número e calcula
#            a sua raiz quadrada usando o método de Newton-Raphson
#            Para encontrarmos a raiz quadrada de um número Q, usamos o seguinte 
#            algoritmo, nas iterações n=0,1,2,3, ...
#            (a) fazemos x(n), com n=0, uma estimativa da raiz quadrada: x(0) = valor estimado
#            (b) para n = 0, 1, 2, ... realizamos as seguintes iterações
#                (b.1) x(n+1) = ( x(n) + Q/x(n) ) * 1/2
#                (b.2) verificamos se abs( x(n+1) - x(n) ) é menor ou igual a um erro
#                (b.3) se a condição b.2 é verdadeira, o valor da raiz quadrada é
#                      igual a x(n+1), com uma tolerância dada pelo valor de erro.
#                      Se a condição b.2 é falsa, fazemos n = n + 1 e repetimos uma
#                      nova iteração.
#   exemplo: Q = 10. Escolhemos um valor para x(0) = 5 e erro = 1e-10
#            x(1) = (x(0)+Q/x(0)) * 1/2 = (5 + 10/5) * 0,5 = 3,5
#            abs( 3,5 - 5) = 1,5. Como este valor é maior que o erro fazemos 
#            n=1 e repetimos.
#            x(2) = (x(1) + Q/x(1)) = (3,5+10/3,5) * 0,5 = 3,178571429
#            abs( 3,178571429-3,5) = 0,3214285714. Como este valor é maior que 
#            o erro fazemos n=1 e repetimos ...
#            O processo termina quando abs( x(n+1)-x(n) ) <= erro.
#            

.text

# diretiva que substitui a string printStringService pelo identificador 4
.eqv printStringService 4

# definição de uma macro
.macro imprimeString(%endString)
    la $a0, %endString
    li $v0, printStringService
    syscall
.end_macro

################################################################
main:
#---------------------------------------------------------------
    jal     introducao          # explica resumidamente este programa
    jal     leiaNumeroPF        # Lê um número em ponto flutuante
    mov.d   $f12, $f0           # $f12 é o primeiro argumento para a função
                                # que calcula a raiz quadrada
    jal     calculaRaizQuadrada # Calcula o valor da raiz quadrada
    mov.d   $f12, $f0           # $f12 é o primeiro argumento de apresentaResultado
    jal     apresentaResultado  # Apresenta o valor da raiz quadrada
    j       terminaPrograma     # Termina a execução do programa
################################################################
    
################################################################
introducao:
#---------------------------------------------------------------
    imprimeString(msg_introducao)
    jr         $ra
################################################################

################################################################
# imprime uma mensagem, pedindo a entrada de um número
# leia um numero em ponto flutuante no formato duplo
leiaNumeroPF:
#---------------------------------------------------------------
    imprimeString(msg_entreNumero)
    li      $v0, 7             # serviço para ler um número em ponto flutuante
    syscall                    # faz uma chamada ao sistema
    jr      $ra                # retorna em $f0 número em ponto flutuante, precisão dupla
################################################################
    
    
################################################################
calculaRaizQuadrada:
#---------------------------------------------------------------
prologo:
    addi    $sp, $sp, -8       # ajusta a pilha para receber 2 itens    
    sw      $s0, 4($sp)        # guarda $s0 na pilha
    sw      $ra  0($sp)        # guarda $ra na pilha
corpo_procedimento:
# $f12 armazena o número Q para encontrarmos a raiz quadrada
    mov.d   $f2, $f12           # $f2 = Q
    mov.d   $f4, $f12           # $f4 = x0 = Q
    l.d     $f8, const2         # $f8 = constante 2
    l.d     $f10, erro          # $f10 = erro máximo entre iterações do método
    li      $s0, 0              # inicializa o contador de iterações
loop:                           #
    mov.d   $f14, $f4           # $f14 = x_n
    div.d   $f6, $f2, $f4       # $f6 = Q/x_n
    add.d   $f4, $f6, $f4       # $f4 = x_n + Q/x_n
    div.d   $f4, $f4, $f8       # $f4 = (x_n+Q/x_n)/2 = x_n+1
# imprime o número em ponto flutuante em $f12:$f13 (formato duplo)
    mov.d   $f12, $f4           # $f12 = x_n+1
    addi    $s0, $s0, 1         # incrementa o contador das iterações
    move    $a0, $s0            # 
    jal apresentaIteracaoValor

    sub.d   $f14, $f4, $f14     # $f14 = x_n+1 - x_n
    abs.d   $f14, $f14          # $f14 = |x_n+1 - x_n |
    c.le.d  $f14, $f10          #  |x_n+1 - x_n |<= erro?
    bc1f    loop                # se falso, nova iteração
    mov.d   $f0, $f4            # guarda em $f0 o valor de retorno
epilogo:                        #
    lw      $s0, 4($sp)         # restaura $s0
    lw      $ra, 0($sp)         # restaura $ra
    addi    $sp, $sp, 8         # restaura a pilha
    jr      $ra                 # retorna ao procedimento chamador
################################################################


################################################################
apresentaIteracaoValor:
    li      $v0, 1              # imprime a iteração
    syscall                     #
    li      $a0, ':'            # imprime dois pontos
    li      $v0, 11             #
    syscall
    li      $v0,3               # serviço para imprimir o número em ponto flutuante em $f12:$f13
    syscall                     # chamada ao sistema
    # pula para a próxima linha
    li      $a0, '\n'           # caracter de retorno de carro
    li      $v0, 11             # serviço para imprimir um caracter
    syscall                     # chamada ao sistema
    jr      $ra
################################################################

################################################################        
apresentaResultado:
# imprime o resultado
    # imprimeString(msg)
    la      $a0, msg            # $a0 <- endereço da string
    li      $v0, 4              # serviço imprime  string
    syscall                     # chamada ao sistema
    li      $v0,3               # serviço para imprimir o número em ponto flutuante em $f12:$f13
    syscall                     # chamada ao sistema
    jr      $ra
################################################################

################################################################
terminaPrograma:
# sai do programa
    li     $v0, 10              # serviço exit
    syscall                     # chamada ao sistema
################################################################
    
.data
const2:             .double 2.0
erro:               .double 1e-9
msg_introducao:     .ascii  "Este programa calcula a raiz quadrada de um número,\n"
                    .asciiz "usando o método de Newton-Raphson\n\n"
msg_entreNumero:    .asciiz "Entre com um número: "                    
msg:                .asciiz "    O resultado é: "
    
    
