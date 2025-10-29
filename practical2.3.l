%{
#include <stdio.h>
%}

%%
[a-zA-Z_][a-zA-Z0-9_]*    { printf("Valid Identifier: %s\n", yytext); }
[ \t\n\r]+                { /* Ignore whitespace */ }
[^a-zA-Z0-9_ \t\n\r]+     { printf("Invalid Identifier: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}