%{
#include "y.tab.h"   // <-- required so Flex knows tokens like LT, LE, etc.
#include <stdio.h>
#include <stdlib.h>
%}

%%

"for"           { return FOR; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"<="            { return LE; }
">="            { return GE; }
"<"             { return LT; }
">"             { return GT; }
"="             { return ASSIGN; }
"++"            { return INC; }
"+"             { return PLUS; }
";"             { return SEMI; }

[0-9]+          { yylval.num = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

[ \t\n]+        ;       // ignore whitespace
.               ;       // ignore unknown chars
%%

int yywrap(void) { return 1; }
