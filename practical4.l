%{
#include "y.tab.h"

int ans;
%}

%%

[0-9]+(\.[0-9]+)?    { yylval.num = atof(yytext); return NUMBER; }
[+\-*/^()]           { return yytext[0]; }
\n                   { return '\n'; }
[ \t]                ;  
.                    { printf("Invalid character: %s\n", yytext); }

%%

int yywrap(void)
{
    return 1;
}