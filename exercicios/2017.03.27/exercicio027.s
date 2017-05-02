#*******************************************************************************
# exercicio027.s               Copyright (C) 2015 Giovani Baratto
# This program is free software under GNU GPL V3 or later version
# see http://www.gnu.org/licences
#
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# versão: 0.1
# Descrição: Exemplo de diretiva para armazenar dados estáticos no programa.
#            Tipos de dados. Rótulos.
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

.data
data1:      .ascii  "string com caracteres ascii sem o terminar com o nulo"
data2:      .asciiz "string com caracteres ascii com o terminador nulo"
data3:      .word   0x0000FFFF, 0xAA80AA80, 12345
data4:      .half   0xFFFF, 0xAA80, 12345
data5:      .byte   0xFF, 0xAA, 0x80, 123, 'a'
data6:      .float  12345, -1E-10, 1.23E12
data7:      .double 1234, -1E-10, 1.23E12
teste:      .byte   0x55
varA:       .byte   5
varB:       .byte   6
varC:       .space  1
