#include <stdio.h>
#include <math.h>

int main() {
    printf("=== Programa C Avançado - Calculadora ===\n");
    
    double a = 10.5, b = 3.2;
    
    printf("Número A: %.2f\n", a);
    printf("Número B: %.2f\n", b);
    printf("Soma: %.2f\n", a + b);
    printf("Subtração: %.2f\n", a - b);
    printf("Multiplicação: %.2f\n", a * b);
    printf("Divisão: %.2f\n", a / b);
    printf("Raiz quadrada de A: %.2f\n", sqrt(a));
    
    printf("\n=== Compilado e executado no container Docker! ===\n");
    return 0;
}