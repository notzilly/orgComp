#*******************************************************************************
# exercicio042.s               Copyright (C) 2015 Giovani Baratto
# This program is free software under GNU GPL V3 or later version
# see http://www.gnu.org/licences
#
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# versão: 0.1
# Descrição: Traduzindo a sentença a =  b + 1;
# Documentação:
# Assembler: MARS
# Revisões:
# Rev #  Data       Nome   Comentários
# 0.1    24/08/16   GBTO   versão inicial 
# 0.1.1  28/03/17   GBTO   formatação do código e inclusão de comentários
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                 #
.text
.globl main
main:
            # ...
            # carregamos em um registrador uma cópia do valor de b
            la    $t0, variavelB    # $t0 <- endereço da variável b
            lw    $t1, 0($t0)       # $t1 <- valor da variável b
            addi  $t1, $t1, 1       # $t1 <- b+1
            # salvamos o valor de b+1 (no registrador $t1) em a
            la    $t0, variavelA    # $t0 <- endereço da variável a
            sw    $t1, 0($t0)       # a <- $t0 = b+1
            # ...
.data
variavelA:  .space 4
variavelB:  .word 1234
