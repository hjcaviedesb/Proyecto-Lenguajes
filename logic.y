%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "langFunctions.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
    char*idval;
 }

%token NUMBER ID LQUIT NEWLINE LLEFT LRIGHT LT LE EQ NE GT GE NOT AND OR THEN IFF AG
%token END
%left LPLUS LMINUS
%left LMULTIPLY LDIVIDE
%right NOT
%right UMINUS

%type <idval> ID
%type <fval> expr NUMBER group
%type <fval> atom biconditional conditional conjunction disjunction literal atomString
%start calculation

%%

calculation: 
    | calculation lines
;

lines: NEWLINE
    | expr END NEWLINE {printf("\tResult: %f\n", $1); }
    | LQUIT  NEWLINE {printf("bye!\n"); exit(0); }
    | biconditional END NEWLINE{printResult($1);}
    | assign NEWLINE
    | ID END NEWLINE {printResult(searchValue(searchIdentifier($1)));}
;

assign: 
    ID AG ID END {storeIdentifier($1,$3);}

expr:
    expr LPLUS expr {$$ = $1 + $3;} 
    |expr LMINUS expr {$$ = $1 - $3;}
    |expr LMULTIPLY expr {$$ = $1 * $3;}
    |expr LDIVIDE expr {$$ = $1 / $3;}
    |LLEFT expr LRIGHT {$$ = $2;}
    |LMINUS expr %prec UMINUS {$$ = - $2;}
    |NUMBER 
;

biconditional:
    conditional IFF biconditional {$$ = checkBiconditional($1,$3);} 
    | conditional
    | group 
;

conditional:
    conjunction THEN conditional { $$ = checkConditional($1,$3); } 
    | conjunction
;

conjunction:
    disjunction OR conjunction {$$ = $1 || $3;} 
    | disjunction
;

disjunction:
    literal AND disjunction {$$ = $1 && $3;}
    | literal 
;
literal:

    atom {$$ = $1;}
    | NOT atom {$$ = !$2;}
    | atomString {$$ = $1;}
    | NOT atomString {$$ = !$2;}
;
atom:
    NUMBER | group
; 

atomString:
    ID {$$ = searchValue(searchIdentifier($1));}
    | group
;


group:
    LLEFT biconditional LRIGHT {$$ = $2;}
    | "{" biconditional "}" {$$ = $2;} 
    | "["biconditional"]" {$$ = $2;}
;

%%



int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
