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
quit    ["E" | "Q"]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%

{delim}	; // ignore all whitespace
{quit}		    {return LQUIT;}
{number} 	    {yylval.fval = atof(yytext); return NUMBER;}
{id}            {yylval.idval = strdup(yytext); return ID;}
{newline} {return NEWLINE;}
"+"		{return LPLUS;}
"-"		{return LMINUS;}
"*"		{return LMULTIPLY;}
"/"		{return LDIVIDE;}
"("		{return LLEFT;}
")"		{return LRIGHT;}
"<"     {return LT;}
"<="    {return LE;}
":="    {return AG;}
"="    {return AG;}
"=="    {return EQ;}
"!="    {return NE;} 
">"     {return GT;}
">="    {return GE;}
"¬"     {return NOT;}
"&"     {return AND;}
"||"    {return OR;}
"->"    {return THEN;}
"<-->"  {return IFF;}


%%