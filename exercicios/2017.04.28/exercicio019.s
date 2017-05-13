.text
.globl main

# Este programa executa um procedimento que realiza a soma de
# seis números inteiros e armazena em uma variável

#####################################################################
# início do programa
#####################################################################
inicializa:
	j main				# executa o procedimento principal do programa

###########################################################
# int soma6(int a1, int a2, int a3, int a4, int a5, int a6)
# {
#   return a1 + a2 + a3 + a4 + a5 + a6;
# }
###########################################################
# procedimento que retorna a soma dos seis argumentos
###########################################################
soma6:
	lw 	 $t1, 0($sp)	# guarda o argumento a6 da função
	lw 	 $t0, 4($sp) 	# guarda o argumento a5 da função
	add  $t3, $a0, $a1	# $t3 = a1 + a2
	add  $t4, $a2, $a3	# $t4 = a3 + a4
	add  $t5, $t0, $t1	# $t5 = a5 + a6
	add  $v0, $t3, $t4	# $v0 = (a1+a2)+(a3+a4)
	add  $v0, $v0, $t5	# $v0 = (a1+a2)+(a3+a4)+(a5+a6)
	jr 	 $ra			# retorna ao procedimento chamador
#######################################################	
# int main(void)
# { 	
#  int k;
#  k = 0;
#  k = soma6(1,2,3,4,5,6);
#  printf("O resultado e %d\n", k);
#  return 0;
# } 	
#######################################################
# procedimento principal
main:
#######################################################
# int k;
	addi $sp, $sp, -4  	# reservamos na pilha um espaço para k
# k = 0;
	xor  $t0, $t0, $t0
	sw 	 $t0, 0($sp)
# k = soma6(1,2,3,4,5,6);
	addi $sp, $sp, -8 	# reservamos na pilha um espaço para dois argumentos
	li 	 $a0, 1			# coloca os primeiros argumentos da função em $a0-$a3
	li   $a1, 2
	li   $a2, 3
	li   $a3, 4
	li   $t0, 5 		# carrega o valor 5 em um registrador e guarda na pilha 
	sw   $t0, 4($sp)
	li   $t0, 6			# carrega o valor 6 em um registrador e guarda na pilha
	sw   $t0, 0($sp)
	jal  soma6			# chama o procedimento soma6
  	addi  $sp, $sp, 8	# Elimina da pilha dois itens: argumentos 5 e 6
  	sw   $v0, 0($sp)
#  printf("O resultado e %d\n", k);
	la   $a0, str_01 	# imprime uma string
	li   $v0, 4
	syscall
	lw   $a0, 0($sp)	# imprime o valor de k
	li   $v0, 1
	syscall
	li   $a0, '\n'		# imprime um retorno de carro
	li   $v0, 11
	syscall
# libera a pilha
	addi $sp, $sp, 4
# return 0;
	li   $a0, 0			# código de saída 0
	li   $v0, 17 		# serviço 7: termina programa com valor
	syscall				# chamada ao sistema
exit:


.data 
	str_01:.asciiz" O resultado é "
		
