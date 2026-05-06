.file	"fact_simple.cpp"
	.text
# Начало функции factorial(int n)
# В ассемблере имя искажено (mangling) до _Z9factoriali
	.globl	_Z9factoriali
	.type	_Z9factoriali, @function
_Z9factoriali:
.LFB2556:
	.cfi_startproc
	pushq	%rbp              # Сохраняем предыдущий указатель кадра стека
	movq	%rsp, %rbp        # Устанавливаем новый указатель кадра
	
	# Аргумент n (из регистра %edi) кладем в стек: [rbp-20]
	movl	%edi, -20(%rbp)   
	
	# Инициализация res = 1. Переменная res лежит в [rbp-8]
	movq	$1, -8(%rbp)      
	
	# Инициализация счетчика цикла i = 1. Переменная i лежит в [rbp-12]
	movl	$1, -12(%rbp)     
	
	jmp	.L2               # Прыгаем к проверке условия цикла
.L3:
	# ТЕЛО ЦИКЛА
	movl	-12(%rbp), %eax   # Берем i
	cltq                      # Расширяем i до 64 бит для умножения
	movq	-8(%rbp), %rdx    # Берем текущий res
	imulq	%rdx, %rax        # res * i
	movq	%rax, -8(%rbp)    # Сохраняем результат обратно в res
	
	addl	$1, -12(%rbp)     # i++ (инкремент счетчика)
.L2:
	# УСЛОВИЕ ЦИКЛА (i <= n)
	movl	-12(%rbp), %eax   # Загружаем i в регистр eax
	cmpl	-20(%rbp), %eax   # Сравниваем i с n ([rbp-20])
	jle	.L3               # Если i <= n, идем на новый круг (в .L3)
	
	# КОНЕЦ ЦИКЛА
	movq	-8(%rbp), %rax    # Кладем финальный res в rax (регистр возврата)
	popq	%rbp              # Восстанавливаем стек
	ret                       # Возвращаемся из функции
	.cfi_endproc

# Секция данных (тут хранятся строки)
	.section	.rodata
.LC0:
	.string	": "
	
	.text
	.globl	main
	.type	main, @function
main:
.LFB2557:
	.cfi_startproc
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx              # Сохраняем rbx (он нам пригодится позже)
	subq	$24, %rsp         # Выделяем место на стеке
	
	# num = 5. Переменная num лежит в [rbp-20]
	movl	$5, -20(%rbp)     
	
	# Готовим вывод в std::cout (выводим число 5)
	movl	-20(%rbp), %eax
	leaq	_ZSt4cout(%rip), %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	_ZNSolsEi@PLT     # Вызов оператора << для int
	
	# Выводим строку ": "
	movq	%rax, %rdx
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	
	# Вызываем нашу функцию factorial(5)
	movq	%rax, %rbx        # Сохраняем объект cout для цепочки вывода
	movl	-20(%rbp), %eax
	movl	%eax, %edi        # Передаем 5 как аргумент
	call	_Z9factoriali     # Прыгаем в factorial
	
	# Выводим результат (из rax) в cout
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	_ZNSolsEy@PLT     # Вызов оператора << для unsigned long long
	
	movl	$0, %eax          # return 0
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	ret     
	.cfi_endproc