%{
#include "y.tab.h"
#include <stdio.h>
%}

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

[ \t\n]+    ;  
","         { return COMMA; }
";"         { return SEMI; }

.           ;   

%%
int yywrap() { return 1; }
