%{
/* definitions of manifest constants */
int yylval;

#define LT 1
#define LE 2
#define NE 3
#define GT 4
#define GE 5
#define IF 6
#define THEN 7
#define ELSE 8
#define ID 9
#define NUMBER 10
#define RELOP 11
#define WHILE 12
#define EQ 13

%}
/* regular definitions */
delim   [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%

{ws} {/* no action and no return */}
if   {return (IF); }
while { return (WHILE);}
then {return (THEN); }
else {return (ELSE) ; }
{id} {yylval = (int) installID(); return (ID); }
{number} {yylval = (int) installNum(); return (NUMBER); }
"<" {yylval = LT; return (RELOP); }
"<=" {yylval = LE; return (RELOP);}
"==" {yylval = EQ; return (RELOP); /* Exercise 3.5.1 - b) */ }
"!=" {yylval = NE; return (RELOP ); /* Exercise 3.5.1 - b) */ }
">" {yylval = GT; return (RELOP); }
">=" {yylval = GE; return (RELOP); }

%%

#include <stdio.h>
#include <stdlib.h>

struct table *idSymbol;
struct table *numSymbol;
 

struct node{
    int key;
    int val;
    struct node *next;
};

struct table{
    int size;
    struct node **list;
};

struct table *createTable(int size){
    struct table *t = (struct table*)malloc(sizeof(struct table));
    t->size = size;
    t->list = (struct node**)malloc(sizeof(struct node*)*size);
    int i;
    for(i=0;i<size;i++)
        t->list[i] = NULL;
    return t;
}

int hashCode(struct table *t,int key){
    if(key<0)
        return -(key%t->size);
    return key%t->size;
}

void insert(struct table *t,int key,int val){
    int pos = hashCode(t,key);
    struct node *list = t->list[pos];
    struct node *newNode = (struct node*)malloc(sizeof(struct node));
    struct node *temp = list;
    while(temp){
        if(temp->key==key){
            temp->val = val;
            return;
        }
        temp = temp->next;
    }
    newNode->key = key;
    newNode->val = val;
    newNode->next = list;
    t->list[pos] = newNode;
}

int lookup(struct table *t,int key){
    int pos = hashCode(t,key);
    struct node *list = t->list[pos];
    struct node *temp = list;
    while(temp){
        if(temp->key==key){
            return temp->val;
        }
        temp = temp->next;
    }
    return -1;
}


int installID() { /* function to install the lexeme, whose first character is pointed to by yytext,
and whose length is yyleng, into the symbol table and return a pointer thereto */

    int value = 0;
    int pos;
    int i = atoi(yytext);
    pos = lookup(idSymbol,i);

    if (pos < 0){
        value = value + 1;
        insert(idSymbol,i,value);
        return value;
    }else{
        return pos;
    }

    return value;


}

int installNum() { /* similar to installID, but puts numerical constants into a seperate table */ 

    int value = 0;
    int pos;
    int i = atoi(yytext);
    pos = lookup(numSymbol,i);

    if (pos < 0){
        value = value + 1;
        insert(numSymbol,i,value);
        return value;
    }else{
        return pos;
    }

    return value;

}




int main(void) { 

    idSymbol = createTable(100);
    numSymbol = createTable(100);
    int val;
    while(val = yylex()) printf("value is %d\n",val);    
    return 0; 
}