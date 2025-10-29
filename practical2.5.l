%{
#include <stdio.h>
%}

%%

"/*"(.|\n)*?"*/"   { /* skip C-style block comments */ }
"//".*             { /* skip single-line comments */ }
.|\n               { printf("%s", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}