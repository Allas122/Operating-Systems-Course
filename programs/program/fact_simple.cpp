#include <iostream>

unsigned long long factorial(int n) {
    unsigned long long res = 1;
    for (int i = 1; i <= n; ++i) {
        res *= i;
    }
    return res;
}

int main() {
    int num = 5;
    std::cout << num << ": " << factorial(num);
}