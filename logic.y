%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
    char* *idval;
 }

%token NUMBER 
%token ID
%token LQUIT
%token NEWLINE
%token LLEFT LRIGHT
%token LT LE EQ NE GT GE
%token NOT AND OR THEN IFF 
%left LPLUS LMINUS
%left LMULTIPLY LDIVIDE
%right UMINUS

%type <fval> expr NUMBER 
%type <idval> ID atom biconditional conditional conjunction disjunction literal
%start calculation

%%

calculation: 
    | calculation lines
;

lines: NEWLINE
    | expr NEWLINE {printf("\tResult: %f\n", $1); }
    | LQUIT NEWLINE {printf("bye!\n"); exit(0); }
    | biconditional NEWLINE{printf("\tResult: %s\n",$1);}
;

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
    conditional IFF biconditional {$$ = $1 + $3;} 
    | conditional 
;
conditional:
    conjunction THEN conditional {$$ = $1 / $3;} 
    | conjunction
;

conjunction:
    disjunction OR conjunction {$$ = $1 ||  $3;} 
    | disjunction
;

disjunction:
    literal AND disjunction {$$ = $1 && $3;}
    | literal 
;
literal:

    atom {$$ = $1;}
    | NOT atom {$$ = !$2;}
;
atom:
    ID 
;
//group:
//    LLEFT biconditional LRIGHT | "{" biconditional "}" | "["biconditional"]" 
//;





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
