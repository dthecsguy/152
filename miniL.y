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
prog: /*empty*/ {pritnf("prog -> epsilon\n");}
	| funcs {pritnf("prog -> funcs\n");};

funcs: func funcs_ {pritnf("funcs -> func funcs_\n");};

funcs_: /*empty*/ {pritnf("funcs_ -> epsilon\n");}
	| func funcs_ {pritnf("\n");};

func: FUNCTION IDENT SEMICOLON BEGIN_PARAMS decls END_PARAMS BEGIN_LOCALS decls END_LOCALS BEGIN_BODY stmts END_BODY {pritnf("func -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS decls END_PARAMS BEGIN_LOCALS decls END_LOCALS BEGIN_BODY stmts END_BODY\n");};
		
decl: idents COLON decl_ {pritnf("decl -> idents COLON decl_\n");};

decl_: ENUM L_PAREN idents R_PAREN {pritnf("decl_ -> ENUM L_PAREN idents R_PAREN\n");}
	| INTEGER {pritnf("decl_ -> INTEGER\n");}
	| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {pritnf("decl_ -> ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
	;
	
stmt: var ASSIGN expr {pritnf("stmt -> var ASSIGN expr\n");}
	| iff {pritnf("stmt -> iff\n");}
	| WHILE be BEGINLOOP stmts ENDLOOP {pritnf("stmt -> WHILE be BEGINLOOP stmts ENDLOOP\n");}
	| DO BEGINLOOP stmts ENDLOOP WHILE be {pritnf("stmt -> DO BEGINLOOP stmts ENDLOOP WHILE be\n");}
	| READ vars {pritnf("stmt -> READ vars\n");}
	| WRITE vars {pritnf("stmt -> WRITE vars\n");}
	| CONTINUE {pritnf("stmt -> CONTINUE\n");}
	| RETURN expr {pritnf("stmt -> RETURN expr\n");}
	;
	
be: rae raes {pritnf("be -> rae raes\n");};

rae: re res {pritnf("rae -> re res\n");};

re: ne ne_o {pritnf("re -> ne ne_o\n");};

comp: EQ {pritnf("comp -> EQ\n");}
	| NEQ {pritnf("comp -> NEQ\n");}
	| LT {pritnf("comp -> LT\n");}
	| LTE {pritnf("comp -> LTE\n");}
	| GT {pritnf("comp -> GT\n");}
	| GTE {pritnf("comp -> GTE\n");}
	;
	
expr: me mes {pritnf("expr -> me mes\n");};

term: nege nege_o {pritnf("term -> nege nege_o\n");}
    | IDENT L_PAREN exprs R_PAREN {pritnf("term -> IDENT L_PAREN exprs R_PAREN\n");}
    ;
	
var: IDENT var_ {pritnf("var -> IDENT var_\n");};

var_: /*empty*/ {pritnf("var_ -> epsilon\n");}
	| L_SQUARE_BRACKET expr R_SQUARE_BRACKET {pritnf("var_ -> L_SQUARE_BRACKET expr R_SQUARE_BRACKET\n");}
	;
	
iff: IF be THEN stmts if_ ENDIF {pritnf("iff -> IF be THEN stmts if_ ENDIF\n");};

if_: /*empty*/ {pritnf("if_ -> epsilon\n");}
	| ELSE stmts {pritnf("if_ -> ELSE stmts\n");}
	;
	
me: term terms {pritnf("me -> term terms\n");};
	
mes: '+' me {pritnf("mes -> \'+\' me\n");}
	| '-' me {pritnf("mes -> \'-\' me\n");}
	;
	
terms: '*' term {pritnf("terms -> \'*\' term\n");}
	| '/' term {pritnf("terms -> \'/\' term\n");}
	| '%' term {pritnf("terms -> \'%\' term\n");}
	;
	
nege: /*empty*/ {pritnf("nege -> epsilon\n");}
	| '-' {pritnf("nege -> \'-\'\n");}
	;

nege_o: var {pritnf("nege_o -> var\n");}
	| NUMBER {pritnf("nege_o -> NUMBER\n");}
	| L_PAREN expr R_PAREN {pritnf("nege_o -> L_PAREN expr R_PAREN\n");}
	;
	
exprs: /*empty*/ {pritnf("exprs -> epsilon\n");}
	| expr exprs_ {pritnf("exprs -> expr exprs_\n");}
	;
	
exprs_: /*empty*/ {pritnf("exprs_ -> epsilon\n");}
	| COMMA expr exprs_ {pritnf("exprs_ -> COMMA expr exprs_\n");}
	;
	
ne_o: expr comp expr {pritnf("ne_o -> expr comp expr\n");}
	| TRUE {pritnf("ne_o -> TRUE\n");}
	| FALSE {pritnf("ne_o -> FALSE\n");}
	| L_PAREN be R_PAREN {pritnf("ne_o -> L_PAREN be R_PAREN\n");}
	;
	
ne: /*empty*/ {pritnf(" ne -> epsilon\n");}
	| NOT {pritnf("ne -> NOT\n");}
	;
	
res: /*empty*/ {pritnf("res -> epsilon\n");}
	| AND re {pritnf("res -> AND re\n");}
	;
	
raes: /*empty*/ {pritnf("raes -> epsilon\n");}
	| OR rae {pritnf("raes -> OR rae\n");}
	;
	
vars: var vars_ {pritnf("vars -> var vars_\n");};

vars_: /*empty*/ {pritnf("vars_ -> epsilon\n");}
	| COMMA var vars_ {pritnf("vars_ -> COMMA var vars_\n");}
	;

idents: IDENT idents_ {pritnf("idents -> IDENT idents_\n");};

idents_: /*empty*/ {pritnf("idents_ -> epsilon\n");}
	| COMMA IDENT idents_ {pritnf("idents_ -> COMMA IDENT idents_\n");}
	;
	
stmts: stmt SEMICOLON stmts_ {pritnf("stmts -> stmt SEMICOLON stmts_\n");};

stmts_: /*empty*/ {pritnf("stmts_ -> epsilon\n");}
	| stmt SEMICOLON stmts_ {pritnf("stmts_ -> stmt SEMICOLON stmts_\n");}
	;
	
decls: /*empty*/ {pritnf("decls -> epsilon\n");}
	| decl SEMICOLON decls_ {pritnf("decls -> decl SEMICOLON decls_\n");}
	;
	
decls_: /*empty*/ {pritnf("decls_ -> epsilon\n");}
	| decl SEMICOLON decls_ {pritnf("decls_ -> decl SEMICOLON decls_\n");}
%%
	/* C functions used in parser */
int main(int argc, char ** argv)
{		
	int i;
	if(argc < 2){
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
			yyparse();
			fclose(f);
		}
	}
}

void yyerror (char const *s)
{
  fprintf (stderr, "There was an error\n: %s", s);
}
