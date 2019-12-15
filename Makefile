all: logic

logic.tab.c logic.tab.h:logic.y
	bison -d logic.y

lex.yy.c: logic.l logic.tab.h
	flex logic.l

logic: lex.yy.c logic.tab.c logic.tab.h
	gcc -o logic logic.tab.c lex.yy.c

clean:
	rm logic logic.tab.c lex.yy.c logic.tab.h