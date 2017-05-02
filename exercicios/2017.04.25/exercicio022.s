
.text
.globl main

#  int global[100];
# int main(void)
# {
#   int local[200];
#  	int* heap;
# 	heap = malloc(1200);
#	free(heap);
# 	return 0;
# }

# procedimento main

main:
	sub		$sp, $sp, 800	# alocamos na pilha o espaço para local[200]
	li 		$a0, 1200		# aloca na heap o espaço para o vetor heap
	li 		$v0, 9			# serviço 9: aloca memoria na heap
	syscall					# chamada ao sistema: aloca memória
	# O Mars não implementa uma função para desalocar a memoria na heap
	move 	$s0, $v0		# $s0 <- endereço de heap
	add 	$sp, $sp, 800	# desalocamos os elemento de local[200] na pilha
	# termina o programa
	li 		$a0, 0			# retorna 0
	li 		$v0, 17			# serviço 17: exit2
	syscall					# faz uma chamada ao sistema

.data 
	global: .space 400
