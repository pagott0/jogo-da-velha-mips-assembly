# Enzo Vasconcellos Pagotto (13632844)
# Guilherme A. Xavier da Silva (14575641)
# Felipe Oliveira Carvalho (14613879)
# Projeto Jogo da Velha (Tic-Tac-Toe)

# Dados inicializados
.data
	msg1: .asciiz "Bem-vindo ao Jogo da Velha"
	turno1: .asciiz "Vez do Jogador 1: "
	turno2: .asciiz "Vez do Jogador 2: "
	vitoria1: .asciiz "Jogador 1 venceu."
	vitoria2: .asciiz "Jogador 2 venceu."
	ultimoempate: .asciiz "Empate."
	linha1: .asciiz "1 2 3"
	linha2: .asciiz "4 5 6"
	linha3: .asciiz "7 8 9"
	guia: .asciiz "Digite a localização [1-9] para jogar o jogo."
	guia1: .asciiz "Jogador 1: X e Jogador 2: O."
	tabuleiro: .asciiz  #usamos grid para armazenar a matriz do Jogo da Velha 3x3
.text

# Exibir a tela principal e guiar o jogador para jogar o jogo
main:
	li $s3, 0
	li $s4, 0
	la $a0, msg1
	li $v0, 4
	syscall
	jal novalinha
	j displayexemplo

# Determinar a vez do Jogador 1 e do Jogador 2
turno:
	jal novalinha
	beq $s3, 0, jogar1 #0 para Jogador 1
	beq $s3, 1, jogar2 #1 para Jogador 2

# Gerenciar a vez do Jogador 1
jogar1:
	la $a0, turno1
	li $v0, 4
	syscall
	jal novalinha
	j jogar

# Gerenciar a vez do Jogador 2
jogar2:
	la $a0, turno2
	li $v0, 4
	syscall
	jal novalinha
	j jogar

# Gerenciar o jogo. Esta função irá pular para três funções: getinput, checkinput e storeinput
jogar:
	jal novalinha
	beq $s4, 9, empate
	jal receberentrada
	jal checarentrada
	j armazenarentrada

# Exibir o exemplo inicial (localização do Jogo da Velha [1-9])
# Carregar e exibir line1, line2, line3, line4
displayexemplo:
	la $a0, linha1
	li $v0, 4
	syscall
	jal novalinha
	la $a0, linha2
	li $v0, 4
	syscall
	jal novalinha
	la $a0, linha3
	li $v0, 4
	syscall
	jal novalinha
	la $a0, guia
	li $v0, 4
	syscall
	jal novalinha
	la $a0, guia1
	li $v0, 4
	syscall
	j turno
# Exibição inicial
display:
	li $s0, 0 #definir $s0 como 0
	li $s1, 0 #definir $s1 como 1
	j displaylinha #pular para displayline

# Para exibir uma nova linha
displaylinha:
	addi $s1, $s1, 3 #adicionar $s1 + 3 para garantir que a cada 3 saídas haja uma nova linha
	jal novalinha
	j displaytabuleiro #pular para displaygrid

# Exibição de todas as informações na matriz
displaytabuleiro:
	beq $s0, 9, checarvitoria #se $s0==9 (todos os valores na matriz estão exibidos), verificar a condição de vitória
	beq $s0, $s1, displaylinha
	addi $s0, $s0, 1 #incrementar $s0
	la $t2, tabuleiro #carregar o endereço atual da matriz
	add $t2, $t2, $s0 #adicionar o endereço com $s0
	lb $t3, ($t2) #carregar o byte de $t2 para $t3
	jal addespaco #adicionar espaço
	beq $t3, 0, displayespaco #se o valor em $t3==0, pular para displayspace
	beq $t3, 1, displayx #se $t3==1, pular para displayx
	beq $t3, 2, displayo #se $t3==2, pular para displayo

# Para exibir 1 como X
displayx:
	li $a0, 88 #carregar X
	li $v0, 11 #exibir X
	syscall
	j displaytabuleiro

# Para exibir 2 como O
displayo:
	li $a0, 79 #carregar O
	li $v0, 11 #exibir O
	syscall
	j displaytabuleiro

# Para exibir ? se o valor na matriz for 0
displayespaco:
	li $a0, 63 #carregar ?
	li $v0, 11 #exibir ?
	syscall
	j displaytabuleiro #voltar para a matriz

# Obter a entrada do usuário
receberentrada:
	li $v0, 5 #ler a localização do jogador
	syscall
	li $s2, 0
	add $s2, $s2, $v0 #adicionar a localização e salvar em $s2
	jr $ra #retornar à função anterior

# Verificar se a entrada está dentro da faixa [1-9]
checarentrada:
	la $t1, tabuleiro #carregar o endereço da matriz
	add $t1, $t1, $s2 #adicionar o valor de $s2 para obter a localização exata
	lb $t2, ($t1) #carregar $t1 para $t2
	bne $t2, 0, turno #verificar se $t2!=0, pular para turno
	bge $s2, 10, turno #verificar se $s2 >= 10, pular para turno
	ble $s2, 0, turno #verificar se $s2 <= 0, pular para turno
	jr $ra #retornar à função anterior

# Armazenar a entrada na matriz
armazenarentrada:
	addi $s4, $s4, 1 #incrementar $s4 a cada jogada
	beq $s3, 0, armazenarx #se for a vez do Jogador 1, pular para armazenarx
	beq $s3, 1, armazenaro #se for a vez do Jogador 2, pular para armazenaro

# Para armazenar a vez do Jogador 1
armazenarx:
	la $t1, tabuleiro #carregar a matriz
	add $t1, $t1, $s2 #adicionar a localização $s2 a $t1 para obter a localização exata
	li $t2, 1
	sb $t2, ($t1) #armazenar $t2 em $t1
	li $s3, 1 #mudar a vez para o Jogador 2
	j display #pular para a exibição

# Para armazenar a vez do Jogador 2
armazenaro:
	la $t1, tabuleiro
	add $t1, $t1, $s2
	li $t2, 2
	sb $t2, ($t1)
	li $s3, 0 #mudar a vez para o Jogador 1
	j display

# Verificar a condição de vitória
checarvitoria:
	bge $s4, 5, vitoriacondicao1 #se $s4>=5, verificar a condição de vitória
	j turno #caso contrário, pular para a vez

# Verificar se todos os valores na primeira linha são iguais
vitoriacondicao1:
	li $s6, 0 #definir $s6 como 0
	li $s5, 1 #definir $s5 como 1
	la $t1, tabuleiro #carregar a matriz em $t1
	add $t1, $t1, $s5 #adicionar $s5 a $t1 para acessar o valor na posição 1
	lb $t2, ($t1) #carregar $t1 em $t2
	addi $t1, $t1, 1 #incrementar endereço $t1 + 1
	lb $t3, ($t1) #carregar $t1 em $t3
	addi $t1, $t1, 1 #incrementar endereço $t1 + 1
	lb $t4, ($t1) #carregar $t1 em $t4
	add $s6, $s6, $t2 #adicionar $s6 + $t2 para verificação posterior
	bne $t2, $t3, vitoriacondicao2 #verificar se os valores são iguais, pular para a próxima condição de vitória
	bne $t3, $t4, vitoriacondicao2 #verificar se os valores são iguais, pular para a próxima condição de vitória
	beq $t2, 0, vitoriacondicao2 #verificar se $t2 é igual a 0 (vazio), pular para a próxima condição de vitória
	j vitoria #caso contrário, pular para a vitória

# Verificar se todos os valores na primeira coluna são iguais
vitoriacondicao2:
	li $s6, 0
	li $s5, 1
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao3
	bne $t3, $t4, vitoriacondicao3
	beq $t2, 0, vitoriacondicao3
	j vitoria

# Verificar se a posição 1,5,9 (diagonal) tem o mesmo valor
vitoriacondicao3:
	li $s6, 0
	li $s5, 1
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 4
	lb $t3, ($t1)
	addi $t1, $t1, 4
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao4
	bne $t3, $t4, vitoriacondicao4
	beq $t2, 0, vitoriacondicao4
	j vitoria

# Verificar se todos os valores na segunda coluna são iguais
vitoriacondicao4:
	li $s6, 0
	li $s5, 2
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao5
	bne $t3, $t4, vitoriacondicao5
	beq $t2, 0, vitoriacondicao5
	j vitoria

# Verificar se todos os valores na segunda linha são iguais
vitoriacondicao5:
	li $s6, 0
	li $s5, 4
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 1
	lb $t3, ($t1)
	addi $t1, $t1, 1
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao6
	bne $t3, $t4, vitoriacondicao6
	beq $t2, 0, vitoriacondicao6
	j vitoria

# Verificar se a posição 3,5,7 (segunda diagonal) é igual
vitoriacondicao6:
	li $s6, 0
	li $s5, 3
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 2
	lb $t3, ($t1)
	addi $t1, $t1, 2
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao7
	bne $t3, $t4, vitoriacondicao7
	beq $t2, 0, vitoriacondicao7
	j vitoria

# Verificar se todos os valores na terceira coluna são iguais
vitoriacondicao7:
	li $s6, 0
	li $s5, 3
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, vitoriacondicao8
	bne $t3, $t4, turno #verificar se $t2!=t$t3, retornar a vez
	beq $t2, 0, vitoriacondicao8 #verificar se $t2 tem valores ausentes, retornar a vez
	j vitoria #caso contrário, pular para a vitória

# Verificar se todos os valores na terceira linha são iguais
vitoriacondicao8:
	li $s6, 0
	li $s5, 7
	la $t1, tabuleiro
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 1
	lb $t3, ($t1)
	addi $t1, $t1, 1
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, turno #verifica se $t2!=t$t3, retorn a vez.
	bne $t3, $t4, turno #verifica se $t4!=t$t3, retorna a vez.
	beq $t2, 0, turno #verifica se $t2 tem valores faltando, retorna a vez.
	j vitoria #caso contrário, jump para a vitória.

# Para criar uma nova linha
novalinha:
	li $a0, 10 #carregar nova linha
	li $v0, 11 #exibir nova linha
	syscall
	jr $ra
# Para adicionar espaço
addespaco:
	li $a0, 32 #carregar espaço
	li $v0, 11 #exibir espaço
	syscall
	jr $ra

# Exibir o vencedor
vitoria:
	beq $s6, 1, player1vence #verificar se $s6==1 (X), pular para player1vence
	beq $s6, 2, player2vence #verificar se $s6==2 (O), pular para player2vence

# Carregar e exibir vitoria1
player1vence:
	jal novalinha
	la $a0, vitoria1
	li $v0, 4
	syscall
	j fim

# Carregar e exibir vitoria2
player2vence:
	jal novalinha
	la $a0, vitoria2
	li $v0, 4
	syscall
	j fim

# Carregar e exibir ultimoempate
empate:
	jal novalinha
	la $a0, ultimoempate
	li $v0, 4
	syscall
	j fim

# Sair do programa
fim:
	li $v0, 10
	syscall
