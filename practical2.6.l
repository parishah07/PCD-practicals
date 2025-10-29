%{
#include <stdio.h>
%}

%%
[0-9]+        { printf("NUMBER: %s\n", yytext); }
[0-9]+\.[0-9]+  {    printf("FLoat: %s\n",yytext);   }
"+"           { printf("PLUS\n"); }
"-"           { printf("MINUS\n"); }
"*"           { printf("MULTIPLY\n"); }
"/"           { printf("DIVIDE\n"); }
"="           { printf("EQUALS\n"); }
"("           { printf("LPAREN\n"); }
")"           { printf("RPAREN\n"); }
[ \t\n]+      ; // ignore whitespace
.             { printf("UNKNOWN: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}