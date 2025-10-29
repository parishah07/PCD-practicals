%{
    #include<stdio.h>
    #include<conio.h>
    int characters=0;
    int words=0;
    int lines=0;
%}

%option noyywrap

%%
\n          { lines++; characters++; }
[a-zA-Z]+   { words++; characters += yyleng; }
[ \t]       {  }
.           { characters++; }
%%

int main()
{
    yylex();
    printf("%d characters\n", characters);
    printf("%d words\n", words);
    printf("%d lines\n", lines);
    return 0;
}