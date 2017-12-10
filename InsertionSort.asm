#Insertion sort for reduced ISA implementation of MIPS
#Julio, Victor, Eduardo
#we try to optimize the code in order to use as few different instructions as possible
.text 
#this is for testing only:
	addi $a0, $0, 12	#a0 should stop when a0 = 0
	
start:
#loading the address of order and signedData inputs
	la $s6, order
	la $s7, signedData
#this is for testing purposes only:
	add $s6, $s6, $a0	#sets the value of order
	add $s7, $s7, $a0	#sets the value of signedData
#testing code ends here

#the actual code begins here
	la $s1, array	 	#s1 holds pointer to array
	la $s2, size
	lw $s2, 0($s2) 	        #s2 holds size value
	lw $s6, 0($s6)          #s6 holds order
	lw $s7, 0($s7)          #s7 holds signedData
	addi $t1, $0, 4		#i <- 1 (4bytes of width)
	
for_comparison:	
	beq $t1, $s2 return    #if i < size 
	
	add $t2, $t1, $s1      #t2 holds pointer to array[i]
	lw $s3, 0($t2)         #s3 holds eleito variable	eleito = array[i]
	addi $t3, $t1, -4      #t3 holds j variable		j = i -1
	
while_comparison:
	slt $t5, $t3, $0	#j must be bigger than 0 so, if j < 0, set t5 to 1
	bne $t5, $0, for_inc	#if j < 0, exit the loop
	
	#fetch array[j]
	add $t6, $s1, $t3	#t6 holds pointer to array[j]
	lw  $s4, 0($t6)		#s4 holds array[j]
	
	#makes signed or unsigned comparison, based on signedData parameter
	beq $0, $s7, unsigned	#if signedData is 0, we make an unsigned comparison
signed:
	slt $t7, $s3, $s4	#t7 holds (eleito < array[j])
	beq $0, $0, sorting_comparison	#a poor man's unconditional jump
unsigned:
	sltu $t7, $s3, $s4      # eleito < array[j], but unsigned
sorting_comparison:
	#here we use the following statement: !(j < 0) and order xor (eleito < array[j])
	#this sets sort order
	xor $t8, $t7, $s6 	# order xor (eleito < array[j])
	bne $t8, $0, for_inc	#if (ordern XNOR (eleito < array[j]) then leave loop	
	
while_body:
	addi $t6, $t6, 4	#pointer to array[j+1]
	sw   $s4, 0($t6)	# array[j+1] = array[j]
	addi $t3, $t3, -4 	#j--
	beq $0, $0, while_comparison	#reset the loop
	
for_inc:
	add $t6, $s1, $t3	#t6 holds pointer to array[j]
	addi $t6, $t6, 4	#pointer to array[j+1]
	sw  $s3, 0($t6) 	#array[j+1] = eleito	
	
	addi $t1, $t1, 4	#i++
	beq $0, $0, for_comparison	#returns to the begging of loop
	
return:
	#this code resets the base parameters for order and signedData, 
	#so that we can run this program 4 times and test all possible combinations
	beq $a0, $0, stop	#stops the program after testing
	addi $a0, $a0, -4	#a0 --
	beq $0, $0, start	#resets the program
	
stop:
	#ends code
.data 
	size: .word 24			#number of BYTES 
	array: .word 5 8 -8 7 -1 5
	signedData: .word 0 0 1 1
	order: .word 0 1 0 1
	
	
