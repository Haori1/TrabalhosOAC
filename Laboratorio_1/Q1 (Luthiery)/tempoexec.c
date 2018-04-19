#include <stdio.h>

int main() {
	
	int n;
	for (int i = 0; i < 19; i++) {
		printf("Qtd de instruções: ");
		scanf("%d", &n);

		printf("instruções: %d\n", n);
		printf("tempo de execução: %.9lf segundos\n\n", (n / 50e6));

		if (n == 11)
			break;
	}

	return 0;
}