%{
#include <stdio.h>
%}

%%
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}    { printf("Email: %s\n", yytext); }
.|\n                                              ; // skip everything else
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}