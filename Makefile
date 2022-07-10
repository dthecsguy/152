parse: miniL.lex miniL.y
	bison -v -d --file-prefix=y miniL.y
	flex miniL.lex
	gcc -o miniL y.tab.c lex.yy.c
	
just-flex: miniL.lex
	flex miniL.lex
	gcc -o miniL lex.yy.c

clean:
	rm -f lex.yy.c y.tab.* y.output *.o miniL *.c