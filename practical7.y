%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expr.h"

int yylex(void);
extern FILE *yyin;
void yyerror(char *s) { fprintf(stderr, "Error: %s\n", s); }

%}

%union {
    int num;
    char* id;
    Expr* expr;
}

%token <id> ID
%token <num> NUM
%token IF ELSE WHILE
%token INT
%token PLUS MINUS MUL DIV ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE

%type <expr> E

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%left PLUS MINUS
%left MUL DIV

%%

program:
    stmt_list
    ;

stmt_list:
    stmt_list S
    | /* empty */
    ;

S:
    ID ASSIGN E SEMI {
        printf("%s = %s\n", $1, $3->place);
    }
    | IF LPAREN E RPAREN S %prec LOWER_THAN_ELSE {
        char* L1 = newlabel(); 
        char* L2 = newlabel(); 
        printf("ifFalse %s goto %s\n", $3->place, L1);
        printf("goto %s\n", L2);
        printf("%s:\n", L1);
        printf("%s:\n", L2);
    }
    | IF LPAREN E RPAREN S ELSE S {
        char* L1 = newlabel(); 
        char* L2 = newlabel(); 
        printf("ifFalse %s goto %s\n", $3->place, L1);
        printf("goto %s\n", L2);
        printf("%s:\n", L1);
        printf("%s:\n", L2);
    }
    | WHILE LPAREN E RPAREN S {
        char* L1 = newlabel(); 
        char* L2 = newlabel(); 
        printf("%s:\n", L1);
        printf("ifFalse %s goto %s\n", $3->place, L2);
        printf("goto %s\n", L1);
        printf("%s:\n", L2);
    }
    | LBRACE stmt_list RBRACE
    ;

E:
    E PLUS E {
        $$ = malloc(sizeof(Expr));
        $$->place = newtemp();
        printf("%s = %s + %s\n", $$->place, $1->place, $3->place);
    }
    | E MINUS E {
        $$ = malloc(sizeof(Expr));
        $$->place = newtemp();
        printf("%s = %s - %s\n", $$->place, $1->place, $3->place);
    }
    | E MUL E {
        $$ = malloc(sizeof(Expr));
        $$->place = newtemp();
        printf("%s = %s * %s\n", $$->place, $1->place, $3->place);
    }
    | E DIV E {
        $$ = malloc(sizeof(Expr));
        $$->place = newtemp();
        printf("%s = %s / %s\n", $$->place, $1->place, $3->place);
    }
    | LPAREN E RPAREN { $$ = $2; }
    | NUM {
        $$ = malloc(sizeof(Expr));
        $$->place = malloc(20);
        sprintf($$->place, "%d", $1);
    }
    | ID {
        $$ = malloc(sizeof(Expr));
        $$->place = strdup($1);
    }
    ;

%%

int main() {
    FILE *fp = fopen("input.c", "r");
    if(!fp) { perror("Cannot open file input.c"); return 1; }
    yyin = fp;
    yyparse();
    fclose(fp);
    return 0;
}
