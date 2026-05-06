#include "factorial.h"

unsigned long long factorial(int n){
    unsigned long long res = 1;
    for (int i = 1; i <= n; ++i) {
        res *= i;
    }
    return res;
};