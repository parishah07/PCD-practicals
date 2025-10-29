%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct Symbol {
    char name[MAX];
    char type[MAX];
    int line;
    char scope[MAX];
    struct Symbol *next;
} Symbol;

Symbol *head = NULL;
char current_type[MAX] = "";
int yylineno = 1;

// Function to check if identifier already exists
int exists(char *name) {
    Symbol *temp = head;
    while (temp) {
        if (strcmp(temp->name, name) == 0) return 1;
        temp = temp->next;
    }
    return 0;
}

// Insert identifier into symbol table
void insertSymbol(char *name, int line) {
    if (exists(name)) return;

    Symbol *node = (Symbol *)malloc(sizeof(Symbol));
    strcpy(node->name, name);
    strcpy(node->type, current_type);
    strcpy(node->scope, "global");
    node->line = line;
    node->next = head;
    head = node;

    printf("Identifier: %s (line %d)\n", name, line);
}

// Print the final symbol table
void printSymbolTable() {
    printf("\nSymbol Table:\n");
    printf("--------------------------------------------------\n");
    printf("Identifier      Line       Scope     \n");
    printf("--------------------------------------------------\n");

    Symbol *temp = head;
    while (temp) {
        printf("%-15s %-10d %-10s\n", temp->name, temp->line, temp->scope);
        temp = temp->next;
    }
}
%}

%option noyywrap

%x TYPE

%%

"int"      { strcpy(current_type, "int"); printf("Keyword: int\n"); BEGIN(TYPE); }
"float"    { strcpy(current_type, "float"); printf("Keyword: float\n"); BEGIN(TYPE); }
"char"     { strcpy(current_type, "char"); printf("Keyword: char\n"); BEGIN(TYPE); }
"return"   { printf("Keyword: return\n"); }

<INITIAL,TYPE>[a-zA-Z_][a-zA-Z0-9_]* {
    if (strlen(current_type) > 0) {
        insertSymbol(yytext, yylineno);
        BEGIN(INITIAL);
    }
    else {
        printf("Identifier: %s (line %d)\n", yytext, yylineno);
    }
}

\n         { yylineno++; }
[ \t]+     { /* skip whitespace */ }
.          { /* skip all other characters */ }

%%

int main() {
    printf("Enter code (Ctrl+D to end):\n");
    yylex();
    printSymbolTable();
    return 0;
}