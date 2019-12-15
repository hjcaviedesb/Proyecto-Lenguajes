%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "logic.tab.h"

%}

/* regular definitions */
delim   [ \t]
newline [\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
quit    ["exit" | "quit"]
%%

{delim}	; // ignore all whitespace
{quit}		{return LQUIT;}
{number} 	    {yylval.fval = atof(yytext); return NUMBER;}
{id}            {yylval.idval = (yytext); return ID;}
{newline} {return NEWLINE;}
"+"		{return LPLUS;}
"-"		{return LMINUS;}
"*"		{return LMULTIPLY;}
"/"		{return LDIVIDE;}
"("		{return LLEFT;}
")"		{return LRIGHT;}
"<"     {return LT;}
"<="    {return LE;}
"=="    {return EQ;}
"!="    {return NE;} 
">"     {return GT;}
">="    {return GE; }
"¬"     {return NOT;}
"&"     {return AND;}
"||"     {return OR;}
"->"    {return THEN;}
"<-->"  {return IFF;}

%%