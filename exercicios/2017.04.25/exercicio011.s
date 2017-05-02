###############################################################################
# exemplo de um procedimento que incrementa um inteiro k
###############################################################################

###############################################################################
.text
.globl main		# main pode ser referenciado em outros arquivos
###############################################################################

###############################################################################
	# int main(void)
	# {
	#    int k;
	#    k = 10;
	#    k = incrementa(k);
	#    return 0;
	# }
#------------------------------------------------------------------------------
main:
#------------------------------------------------------------------------------
# prologo
	addiu	$sp, $sp, -4		# ajusta a pilha para um elemento
# corpo do programa
	li		$t0, 0x0000000A		# $t0 <- 10	
	sw		$t0, 0($sp)			# k = 10;
	# chama o procedimento incrementa
	addu 	$a0, $zero, $t0		# $a0 <- k
	# move $a0, $s0				# poderíamos ter usado esta pseudo-intrucao
	jal 	incrementa			# chama o procedimento incrementa
	sw		$v0, 0($sp)			# k = incrementa(k);
# epílogo
	addiu	$sp, $sp, 4			# restauramos a pilha
# encerramos o programa
	li 		$a0, 0				# valor de retorno de main igual a 0
	li 		$v0, 17				# usamos o serviço 17 -> encerra o programa
	syscall						# fazemos uma chamada ao sistema
# fim do procedimento main	
###############################################################################

###############################################################################
	# procedimento incrementa
	# int incremementa(int i){
	#    int j;
	#    j = i + 1;
	#    return j;
	# }			
#------------------------------------------------------------------------------	
incrementa:
#------------------------------------------------------------------------------
	add		$v0, $a0, 1			# v0 <- i + 1
	jr 		$ra 				# retorna ao procedimento chamador
# fim do procedimento incrementa	
###############################################################################	

