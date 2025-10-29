%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);

typedef struct {
    char *init_var;
    int init_val;
    int limit;
    char *body;
} Loop;
%}

%union {
    int num;
    char *str;
    Loop loop;
}

%token FOR LPAREN RPAREN LBRACE RBRACE ASSIGN LT GT LE GE PLUS INC SEMI
%token <num> NUM
%token <str> ID
%type <loop> loop
%type <str> stmt

%%

program:
    loop { printf("\nOptimized code:\n%s\n", $1.body); }
    ;

loop:
    FOR LPAREN ID ASSIGN NUM SEMI ID LT NUM SEMI ID INC RPAREN LBRACE stmt RBRACE
    {
        Loop L;
        L.init_var = $3;
        L.init_val = $5;
        L.limit = $9;

        int factor = 2;  // unroll factor
        char buffer[1024];
        sprintf(buffer, "for (%s=%d; %s<%d; %s+=%d) {\n",
                $3, $5, $7, $9, $11, factor);

        // unroll
        for (int k = 0; k < factor; k++) {
            char temp[256];
            sprintf(temp, "    %s // iteration +%d\n", $15, k);
            strcat(buffer, temp);
        }

        strcat(buffer, "}\n");
        L.body = strdup(buffer);
        $$ = L;
    }
    ;

stmt:
    ID ASSIGN ID PLUS ID SEMI
    {
        char buf[256];
        sprintf(buf, "%s = %s + %s;", $1, $3, $5);
        $$ = strdup(buf);
    }
    ;

%%

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main(void) {
    printf("Enter loop:\n");
    yyparse();
    return 0;
}
