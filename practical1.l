%{
    #include<stdio.h>
    #include<conio.h>
%}

%option noyywrap

%%
int|char|float { printf("%s is the keyword is valid",yytext);}
%%

int main()
{
    yylex();
    return 0;
}