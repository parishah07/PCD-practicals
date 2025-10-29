%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
extern FILE *yyin;

struct Symbol {
    char name[30];
    char datatype[15];
    struct Symbol *next;
};

struct Symbol *head = NULL;

void insertSymbol(char *name, char *datatype) {
    struct Symbol *temp = head;
    while (temp != NULL) {
        if (strcmp(temp->name, name) == 0) {
            printf("Warning: duplicate identifier %s\n", name);
            return;
        }
        temp = temp->next;
    }

    struct Symbol *newNode = (struct Symbol*)malloc(sizeof(struct Symbol));
    strcpy(newNode->name, name);
    strcpy(newNode->datatype, datatype);
    newNode->next = NULL;

    if (head == NULL) {
        head = newNode;
    } else {
        struct Symbol *t = head;
        while (t->next != NULL) t = t->next;
        t->next = newNode;
    }

    printf("Inserted: %-10s | Type: %s\n", name, datatype);
}

void printTable() {
    struct Symbol *temp = head;
    printf("\n=== SYMBOL TABLE ===\n");
    printf("%-15s %-15s\n", "Identifier", "Datatype");
    printf("--------------------------------\n");
    while (temp != NULL) {
        printf("%-15s %-15s\n", temp->name, temp->datatype);
        temp = temp->next;
    }
}

void yyerror(char *s);
%}

%union {
    char* str;
}

%token <str> ID
%token INT FLOAT CHAR
%token COMMA SEMI

%type <str> decl_list decl T

%%

program:
    program decl_list SEMI
    | decl_list SEMI
    ;

decl_list:
    decl { $$ = $1; }
    | decl_list COMMA ID {
        insertSymbol($3, $1);  
        $$ = $1;               
    }
    ;

decl:
    T ID {
        insertSymbol($2, $1);
        $$ = $1;  
    }
    ;

T:
    INT    { $$ = "int"; }
    | FLOAT { $$ = "float"; }
    | CHAR  { $$ = "char"; }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    FILE *fp = fopen("input.c", "r");
    if (!fp) {
        perror("Cannot open file input.c");
        return 1;
    }

    yyin = fp;    
    yyparse();
    fclose(fp);

    printTable();

    return 0;
}
