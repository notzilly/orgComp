
.text
.globl main

# programa que retorna a soma do maior e do menor valor de 
# uma lista

###############################################################################
# Início do programa
###############################################################################
inicializa:
	j main	# vai para o procedimento principal
	
	

# int menorValor(int a0, int a1, int a2)
# {
#   int menor;
#   menor = a0;
#   if (a1 < menor) menor = a1;
#   if (a2 < menor) menor = a2;
#   return menor;
# }
menorValor:
	move $v0, $a0				# $v0 <- $a0 = menor
	blt $a1, $v0, a1_menor		# $a1 < menor?
compara_a2_menor:
	blt $a2, $v0, a2_menor		# $a2 < menor?
	j fim_compara_menor
a1_menor:
	move $v0, $a1				# menor = a1
	j compara_a2_menor
a2_menor:
	move $v0, $a2				# menor = a2
fim_compara_menor:
	jr $ra						# retorna ao procedimento chamador


# int maiorValor(int a0, int a1, int a2)
# {
#   int maior;
#   maior = a0;
#   if (a1 > maior) maior = a1;
#   if (a2 > maior) maior = a2;
#   return maior;
# }
maiorValor:
	move $v0, $a0			# $v0 <- a0 = maior
	bgt  $a1, $v0, a1_maior  # a1 > maior? 
compara_a2_maior:
	bgt  $a2, $v0, a2_maior	# a2 > maior?
	j fim_compara_maior
a1_maior:
	move $v0, $a1			# maior = a1
	j compara_a2_maior
a2_maior:
	move $v0, $a2			# maior = a2
fim_compara_maior:
	jr   $ra				# retorna ao procedimento chamador			


# int procedimento1(int a0, int a1, int a2)
# {
#   int maior;
#   int menor;
#   maior = maiorValor(a0, a1, a2);
#   menor = menorValor(a0, a1, a2);
#   return maior + menor;
# }
procedimento1:
	# prólogo
	addi  $sp, $sp, -8 		# a pilha irá armazenar dois itens
	sw    $ra, 4($sp)		# armazena $ra
	# corpo do procedimento
	jal maiorValor
	sw	 $v0, 0($sp)
	jal menorValor
	lw   $t0, 0($sp)
	add  $v0, $t0, $v0		# $v0 = maior+menor
	#epílogo
	lw   $ra, 4($sp)		# restaura $ra
	addi $sp, $sp, 8		# libera o espaço na pilha
	jr   $ra				# retorna maior+menor


# int main(void)
# {
#   int k;
#	k = 1000;
#   k = procedimento1(3,1,2);
#   printf("A soma do maior e menor valor da lista é %d\n",k );
#   return 0;
# }
# procedimento main

main:
# int k;
	addi  $sp, $sp, -4		# reserva na pilha um espaço para k
# k = 1000
	addiu $t0, $zero, 1000
	sw    $t0, 0($sp)
#   k = procedimento1(3,1,2);	
	li    $a0, 3			# Os argumentos da função são guradados em $a0 a $a2
	li    $a1, 1
	li    $a2, 2
	jal   procedimento1		# chamamos o procedimento procedimento1
	sw    $v0, 0($sp)		# k = procedimento1()
#   printf("A soma do maior e menor valor da lista é %d\n",k );	
	la    $a0, msg_01		# imprime a mensagem
	li    $v0, 4
	syscall
	lw	  $a0, 0($sp)		# imprime k
	li    $v0, 1
	syscall
	li    $a0, '\n'			# imprime um retorno de carro
	li    $v0, 11
	syscall
# libera o espaço na pilha
	addi  $sp, $sp, 4		# libera o espaço na pilha
# return 0;
	li    $a0, 0 			# termina o programa: return 0;
	li    $v0, 17
	syscall
end_main:

.data
	msg_01: .asciiz "A soma do maior e do menor valor da lista é "

