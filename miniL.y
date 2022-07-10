%{
	#include <stdio.h>
	#include <stdlib.h>
%}

%union{
	char* s;
	int d;
}

/*declare tokens*/
%token COMMA COLON SEMICOLON RETURN FALSE TRUE NOT OR AND WRITE READ CONTINUE BEGIN_BODY END_LOCALS END_PARAMS FUNCTION
%token ENDLOOP BEGINLOOP DO WHILE FOR ELSE ENDIF THEN IF OF ENUM ARRAY INTEGER END_BODY BEGIN_LOCALS BEGIN_PARAMS 

%right ASSIGN
%left AND OR
%right NOT
%left GT GTE LT LTE EQ NEQ
%left '+' '-'
%left '*' '/' '%'
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN

%token <d> NUMBER
%token <s> IDENT

%start prog

%%
prog: /*empty*/ 
	| funcs;

funcs: func funcs_;

funcs_: /*empty*/ 
	| func funcs_;

func: FUNCTION IDENT SEMICOLON 
		BEGIN_PARAMS decls END_PARAMS 
		BEGIN_LOCALS decls END_LOCALS 
		BEGIN_BODY stmts END_BODY;
		
decl: idents COLON decl_;

decl_: ENUM L_PAREN idents R_PAREN
	| INTEGER
	| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
	;
	
stmt: var ASSIGN expr
	| iff
	| WHILE bool-expr BEGINLOOP stmts ENDLOOP
	| DO BEGINLOOP stmts ENDLOOP WHILE bool-expr
	| READ vars
	| WRITE vars
	| CONTINUE
	| RETURN expr
	;
	
be: rae raes;

rae: re res;

re: ne ne_o;

comp: EQ 
	| NEQ 
	| LT 
	| LTE 
	| GT 
	| GTE
	;
	
expr: me mes;

term: nege nege_o
	| IDENT L_PAREN exprs R_PAREN
	;
	
var: IDENT var_;

var_: /*empty*/ 
	| L_SQUARE_BRACKET expr R_SQUARE_BRACKET
	;
	
iff: IF be THEN stmts if_ ENDIF;

if_: /*empty*/
	| ELSE stmts
	;
	
mes: '+' me
	| '-' me
	;
	
terms: '*' term
	| '/' term
	| '%' term
	;
	
nege: /*empty*/ 
	| '-'
	;

nege_o: var
	| NUMBER
	| L_PAREN expr R_PAREN
	;
	
exprs: /*empty*/
	| expr exprs_
	;
	
exprs_: /*empty*/ 
	| COMMA expr exprs_
	;
	
ne_o: expr comp expr
	| TRUE
	| FALSE
	| L_PAREN be R_PAREN
	;
	
ne: /*empty*/
	| NOT
	;
	
res: /*empty*/
	| AND re
	;
	
raes: /*empty*/
	| OR rae
	;
	
vars: var vars_;

vars_: /*empty*/ 
	| COMMA var vars_
	;

idents: ident idents_;

idents_: /*empty*/
	| COMMA ident idents_
	;
	
stmts: stmt SEMICOLON stmts_;

stmts_: /*empty*/
	| stmt SEMICOLON stmts_
	;
	
decls: /*empty*/
	| decl SEMICOLON decls_
	;
	
decls_: /*empty*/
	| decl SEMICOLON decls_
%%
	/* C functions used in parser */
int main(int argc, char ** argv)
{
	int i;
	if(argc < 2){
		my_yylineno = 1;
		yyparse();
	}
	else{
		for(i = 1; i < argc; i++){
			printf("\n\n\nProcessing file %s!!!!!!+++++++++++++\n\n\n", argv[i]);
		
			FILE* f = fopen(argv[i], "r");
			
			if(!f){
				perror(argv[1]);
				return 1;
			}
			
			yyrestart(f);
			my_yylineno = 1;
			yyparse();
			fclose(f);
		}
	}
}
