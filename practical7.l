%{
#include "expr.h"
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"int"           { return INT; }

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.id = strdup(yytext); return ID; }
[0-9]+                    { yylval.num = atoi(yytext); return NUM; }

"{"                       { return LBRACE; }
"}"                       { return RBRACE; }
"("                       { return LPAREN; }
")"                       { return RPAREN; }
"="                       { return ASSIGN; }
";"                       { return SEMI; }
"+"                       { return PLUS; }
"-"                       { return MINUS; }
"*"                       { return MUL; }
"/"                       { return DIV; }

[ \t\n]+                  { /* skip whitespace */ }
.                         { printf("Unknown symbol: %s\n", yytext); }
%%

int yywrap() { return 1; }
