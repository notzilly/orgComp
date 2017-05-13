# Exemplo de um programa que zera os elementos de um vetor
# clear1 usa índices
# clear2 usa ponteiros

.text
.globl main
############################################################
# Procedimento inicial
############################################################
main:
	la   $a0, vector1	# chama o procedimento clear1
	li   $a1, 10		# zera todos os elementos de vetor1
	jal  clear1
	la   $a0, vector2	# chama o procedimento clear2
	li   $a1, 10		# zera todos os elementos de vetor2
	jal  clear2
	j    exit			# termina o prograna
############################################################


############################################################
#Clear1 (int array[ ], int size){
#	Int i;
#	for(i=0; i<size; i=i+1) array[i] = 0;
#}
############################################################
clear1:					# procedimento clear1
	move   $t0, $zero		# i= 0
loop1:
  	sll    $t1, $t0, 2		# t1 <- 4 * i
  	add    $t2, $a0, $t1           	# t1 <- &array[i]
  	sw     $zero, 0($t2)		# array[i] = 0
  	addi   $t0, $t0, 1		# i = i + 1
  	slt    $t3, $t0, $a1		# t3 <- (i<size)?
  	bne    $t3, $zero, loop1	# se t3=1 então vá para loop1
fimClear1: 	
  	jr     $ra			# volta ao procedimento chamador
############################################################
	

############################################################
#Clear2 (int * array, int size){
#	Int *p;
#	for(p=&array[0]; p<&array[size]; p=p+1) *p = 0;
#}
############################################################
clear2:								# procedimento clear2
	move   $t0, $a0					# p = &array[0]
  	sll	   $t1, $a1, 2				# t1 <- size * 4
  	add	   $t2, $a0, $t1			# t2 <- &array[size]
loop2:
  	sw 	   $zero, 0($t0)			# memoria[p] = 0
  	addi   $t0, $t0, 4				# p = p + 4
  	slt	   $t3, $t0, $t2			# t3 <-  (p<&array[size])?
  	bne	   $t3, $zero, loop2		# se t3=1 vá para loop2
fimClear2:
	jr 	   $ra						# retorna ao procedimento chamador
############################################################


############################################################
# encerra o programa.
############################################################
exit:					            	# procedimento exit
	li     $a0, 0	 				# codigo  de retorno igual a 0
	li     $v0, 17 					# chamada a exit2
	syscall
############################################################


.data
	vector1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	vector2: .word -1, -2, -3, -4, -5, -6, -7, -8, -9, -10
