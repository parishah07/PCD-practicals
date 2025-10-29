%{
    #include<stdio.h>
    #include<conio.h>
%}

%option noyywrap

%%
[0-9]+          {   printf("Integer: %s\n",yytext); }
[0-9]+\.[0-9]+  {    printf("FLoat: %s\n",yytext);   }
%%

int main()
{
    yylex();
    return 0;
}