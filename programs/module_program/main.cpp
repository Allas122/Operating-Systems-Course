#include <bits/stdc++.h>
#include <unistd.h>
#include <sys/wait.h> 
#include "factorial.h"


int main() {
    int fd[2];

    if (pipe(fd) == -1) { // Создаю pipe(выделенный файл-дескриптор в ядре) на основе fd(внутри него теперь 2 дескриптора на чтение и на запись)
        std::cerr << "Pipe failed!" << std::endl;
        return 1;
    }

    pid_t pid = fork(); // Создаю дочерний процесс.

    if (pid < 0) {
        std::cerr << "Fork failed!" << std::endl;
        return 1;
    }

    if (pid == 0) { // Для ребёнка(т.к это именно fork) его pid всегда равен 0, так я и проверяю кто должен выполнять этот код.
        close(fd[0]); // Закрываю pipe на чтение(чтобы система не ждала пока я прочту, я, как fork только пишу)
        int number = 10;
        unsigned long long result = factorial(number);

        write(fd[1], &result, sizeof(result)); // пишу в дескриптор записи
        close(fd[1]); // говорю что записал, на этом моменте я говорю системе что запись полностью успешна.
        std::cout << "[Child] Calculated factorial and sent it to Parent." << std::endl;
        exit(0); // Выхожу из форка.    
    } 
    else { // Соотвественно это код родителя.
        close(fd[1]); // говорю что якобы записал то что нужно

        unsigned long long received_result = 0;

        wait(NULL); // Жду пока лочерний процесс закончится(спрашиваю систему, дочерний процесс завершился ? Если нет, то жду)

        read(fd[0], &received_result, sizeof(received_result)); // Читаю из дискриптора чтения
        close(fd[0]); // говорю что прочитал системе.
        
        std::cout << "[Parent] Received result from child: " << received_result << std::endl;
    }

    return 0;
}