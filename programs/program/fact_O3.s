.file	"fact_simple.cpp"
	.text
#APP
	.globl _ZSt21ios_base_library_initv
#NO_APP
	.p2align 4
	.globl	_Z9factoriali
	.type	_Z9factoriali, @function
_Z9factoriali:
.LFB2605:
	.cfi_startproc
	# ПРОВЕРКА ВХОДНОГО ЗНАЧЕНИЯ (n)
	testl	%edi, %edi        # Проверяем n (аргумент лежит в %edi)
	jle	.L4               # Если n <= 0, прыгаем в .L4 (возвращаем 1)
	
	# ПОДГОТОВКА ОПТИМИЗИРОВАННОГО ЦИКЛА
	leal	1(%rdi), %esi     # Рассчитываем границу цикла (n + 1)
	andl	$1, %edi          # Проверка на четность/нечетность для оптимизации
	movl	$1, %eax          # Инициализируем временный счетчик
	movl	$1, %edx          # Инициализируем результат (res = 1)
	je	.L3               # Если n четное, сразу идем в цикл .L3
	
	# ОБРАБОТКА ПЕРВОЙ ИТЕРАЦИИ (если n нечетное)
	movl	$2, %eax          # Начинаем со 2-го элемента
	cmpq	%rsi, %rax        # Сравниваем с границей
	je	.L1               # Если закончили, выходим
	.p2align 5
	.p2align 4
	.p2align 3
.L3:
	# ГЛАВНЫЙ ЦИКЛ (Оптимизация: перемножение по два числа за шаг)
	imulq	%rax, %rdx        # res *= i
	leaq	1(%rax), %rcx     # Вычисляем (i + 1)
	addq	$2, %rax          # i += 2 (шаг цикла через два числа)
	imulq	%rcx, %rdx        # res *= (i + 1)
	cmpq	%rsi, %rax        # Проверка: достигли ли мы n?
	jne	.L3               # Если нет, повторяем цикл
.L1:
	# ВОЗВРАТ РЕЗУЛЬТАТА
	movq	%rdx, %rax        # Помещаем результат в %rax
	ret                       # Выход из функции
	.p2align 4,,10
	.p2align 3
.L4:
	# ОБРАБОТКА СЛУЧАЯ n <= 0
	movl	$1, %edx          # Результат = 1
	movq	%edx, %rax        # Возвращаем 1
	ret
	.cfi_endproc
.LFE2605:
	.size	_Z9factoriali, .-_Z9factoriali
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	": "
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB2606:
	.cfi_startproc
	pushq	%rbx              # Сохраняем регистр rbx в стеке
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	
	# ВЫВОД ЧИСЛА 5
	movl	$5, %esi          # Загружаем число 5 в аргументы
	leaq	_ZSt4cout(%rip), %rdi # Ссылка на стандартный поток cout
	call	_ZNSolsEi@PLT     # Вызов функции вывода cout << 5
	
	# ВЫВОД СТРОКИ ": "
	movl	$2, %edx          # Длина строки
	leaq	.LC0(%rip), %rsi  # Загружаем адрес строки ": "
	movq	%rax, %rbx        # Сохраняем состояние cout в %rbx
	movq	%rax, %rdi        # Передаем cout как объект для вывода
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	
	# ФАНТАСТИЧЕСКАЯ ОПТИМИЗАЦИЯ:
	# Компилятор сам посчитал факториал 5 во время компиляции!
	# Вместо вызова функции _Z9factoriali, он просто вставил готовое число 120.
	movq	%rbx, %rdi        # Снова берем cout
	movl	$120, %esi        # Загружаем готовый результат 120 (5!) в аргументы
	call	_ZNSo9_M_insertIyEERSoT_@PLT # Выводим число 120
	
	xorl	%eax, %eax        # Обнуляем %eax (return 0)
	popq	%rbx              # Восстанавливаем rbx
	.cfi_def_cfa_offset 8
	ret                       # Завершение программы
	.cfi_endproc
.LFE2606:
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.1 20260430"
	.section	.note.GNU-stack,"",@progbits