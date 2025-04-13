#include <stdio.h>
#include <stdlib.h>

extern int yyparse(void);
extern FILE *yyin;
extern int line_num;
int main(int argc, char **argv) {

    if (argc != 2) {
        fprintf(stderr, "Χρήση: %s <αρχείο_myhtml>\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Σφάλμα ανοίγματος αρχείου");
        return 1;
    }

    yyin = inputFile;

    printf("Ανάλυση αρχείου: %s\n\n", argv[1]);
    if (yyparse() == 0) {
        printf("\n✅ Το αρχείο είναι συντακτικά ορθό.\n");
    } else {
        printf("\n❌ Εντοπίστηκαν συντακτικά σφάλματα.\n");
    }

    fclose(inputFile);
    return 0;
}