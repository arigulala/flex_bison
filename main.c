#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>
extern int yyparse(void);
extern FILE *yyin;
extern int has_error;
regex_t url_regex;

int is_valid_url(const char *url)
{
    if (!url)
        return 0;
    size_t len = strlen(url);
    if (len >= 2 && url[0] == '"' && url[len - 1] == '"')
    {
        char *start = strndup(url + 1, len - 2);
        if (!start)
            return 0;
        regex_t regex;
        int result;
        const char *pattern = "^(https?://|/|\\./|\\.\\./|#)?[^[:space:]\"']+$";
        regcomp(&regex, pattern, REG_EXTENDED | REG_NOSUB);
        result = regexec(&regex, start, 0, NULL, 0);
        regfree(&regex);
        free(start);
        return result == 0;
    }
    return 0;
}

int is_valid_href(const char *href)
{
    const char *start = href;
    size_t len = strlen(href);

    // Αφαίρεση εισαγωγικών αν υπάρχουν
    if ((href[0] == '"' && href[len - 1] == '"') ||
        (href[0] == '\'' && href[len - 1] == '\''))
    {
        start = strndup(href + 1, len - 2);
    }
    else
    {
        start = strdup(href);
    }

    int valid = regexec(&url_regex, start, 0, NULL, 0) == 0;

    free((void *)start);
    return valid;
}

int main(int argc, char **argv)
{

    if (argc != 2)
    {
        fprintf(stderr, "Χρήση: %s <αρχείο_myhtml>\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile)
    {
        perror("Σφάλμα ανοίγματος αρχείου");
        return 1;
    }

    if (regcomp(&url_regex, "^(https?://[^\\s\"']+|/[^\\s\"']*|#[^\\s\"']+)$", REG_EXTENDED) != 0)
    {
        fprintf(stderr, "Σφάλμα: δεν έγινε compile το href regex\n");
        return 1;
    }
    yyin = inputFile;
    printf("Ανάλυση αρχείου: %s\n\n", argv[1]);
    if (yyparse() == 0 && has_error == 0)
    {
        printf("\n✅ Το αρχείο είναι συντακτικά ορθό.\n");
    }
    else if (has_error != 0)
    {
        printf("\n❌ Εντοπίστηκαν συντακτικά σφάλματα.\n");
    }
    fclose(inputFile);
    regfree(&url_regex);
    return 0;
}