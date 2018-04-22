#include <stdio.h>
#include <stdbool.h>

int main() {
	
	int inst_int, inst_fp;
	while (true) {
		printf("Qtd de instruções de inteiros: ");
		scanf("%d", &inst_int);
		printf("Qtd de instruções de ponto flutuante: ");
		scanf("%d", &inst_fp);

		printf("Instruções totais: %d\n", inst_int + inst_fp);

		double res = ((1*inst_int) + (10*inst_fp)) / 1e9;			//equação do tempo de execução para essa questão
		printf("Tempo de execução: %.9lf segundos\n\n", res);
	}

	return 0;
}