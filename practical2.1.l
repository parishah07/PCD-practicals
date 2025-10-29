%{
#include <stdio.h>
%}

%%
"int"|"float"|"char"|"return"|"if"|"else"|"while"|"for"   { printf("Keyword: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*                                  { printf("Identifier: %s\n", yytext); }
[0-9]+\.[0-9]+                                          { printf("Float: %s\n", yytext); }
[0-9]+                                                  { printf("Integer: %s\n", yytext); }
[ \t\n]+                                                ; 
.                                                       { printf("Other: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}
int yywrap() {
    return 1;
}