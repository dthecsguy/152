%{
	#include <stdio.h>
	#include <stdlib.h>
	int yydebug = 1;
%}

%union{
	char* s;
	int d;
}

%debug

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
prog: funcs {printf("prog -> funcs\n");};

funcs: func funcs_ {printf("funcs -> func funcs_\n");};

funcs_: /*empty*/ {printf("funcs_ -> epsilon\n");}
	| func funcs_ {printf("\n");};

func: FUNCTION IDENT SEMICOLON BEGIN_PARAMS decls END_PARAMS BEGIN_LOCALS decls END_LOCALS BEGIN_BODY stmts END_BODY {printf("func -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS decls END_PARAMS BEGIN_LOCALS decls END_LOCALS BEGIN_BODY stmts END_BODY\n");};
		
decl: idents COLON decl_ {printf("decl -> idents COLON decl_\n");};

decl_: ENUM L_PAREN idents R_PAREN {printf("decl_ -> ENUM L_PAREN idents R_PAREN\n");}
	| INTEGER {printf("decl_ -> INTEGER\n");}
	| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("decl_ -> ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
	;
	
stmt: var ASSIGN expr {printf("stprintfmt -> var ASSIGN expr\n");}
	| iff {printf("stmt -> iff\n");}
	| WHILE be BEGINLOOP stmts ENDLOOP {printf("stmt -> WHILE be BEGINLOOP stmts ENDLOOP\n");}
	| DO BEGINLOOP stmts ENDLOOP WHILE be {printf("stmt -> DO BEGINLOOP stmts ENDLOOP WHILE be\n");}
	| READ vars {printf("stmt -> READ vars\n");}
	| WRITE vars {printf("stmt -> WRITE vars\n");}
	| CONTINUE {printf("stmt -> CONTINUE\n");}
	| RETURN expr {printf("stmt -> RETURN expr\n");}
	;
	
be: rae raes {printf("be -> rae raes\n");};

rae: re res {printf("rae -> re res\n");};

re: ne ne_o {printf("re -> ne ne_o\n");};

comp: EQ {printf("comp -> EQ\n");}
	| NEQ {printf("comp -> NEQ\n");}
	| LT {printf("comp -> LT\n");}
	| LTE {printf("comp -> LTE\n");}
	| GT {printf("comp -> GT\n");}
	| GTE {printf("comp -> GTE\n");}
	;
	
expr: me mes {printf("expr -> me mes\n");};

term: nege nege_o {printf("term -> nege nege_o\n");}
    | IDENT L_PAREN exprs R_PAREN {printf("term -> IDENT L_PAREN exprs R_PAREN\n");}
    ;
	
var: IDENT var_ {printf("var -> IDENT var_\n");};

var_: /*empty*/ {printf("var_ -> epsilon\n");}
	| L_SQUARE_BRACKET expr R_SQUARE_BRACKET {printf("var_ -> L_SQUARE_BRACKET expr R_SQUARE_BRACKET\n");}
	;
	
iff: IF be THEN stmts if_ ENDIF {printf("iff -> IF be THEN stmts if_ ENDIF\n");};

if_: /*empty*/ {printf("if_ -> epsilon\n");}
	| ELSE stmts {printf("if_ -> ELSE stmts\n");}
	;
	
me: term terms {printf("me -> term terms\n");};
	
mes: '+' me {printf("mes -> \'+\' me\n");}
	| '-' me {printf("mes -> \'-\' me\n");}
	;
	
terms: '*' term {printf("terms -> \'*\' term\n");}
	| '/' term {printf("terms -> \'/\' term\n");}
	| '%' term {printf("terms -> \'%\' term\n");}
	;
	
nege: /*empty*/ {printf("nege -> epsilon\n");}
	| '-' {printf("nege -> \'-\'\n");}
	;

nege_o: var {printf("nege_o -> var\n");}
	| NUMBER {printf("nege_o -> NUMBER\n");}
	| L_PAREN expr R_PAREN {printf("nege_o -> L_PAREN expr R_PAREN\n");}
	;
	
exprs: /*empty*/ {printf("exprs -> epsilon\n");}
	| expr exprs_ {printf("exprs -> expr exprs_\n");}
	;
	
exprs_: /*empty*/ {printf("exprs_ -> epsilon\n");}
	| COMMA expr exprs_ {printf("exprs_ -> COMMA expr exprs_\n");}
	;
	
ne_o: expr comp expr {printf("ne_o -> expr comp expr\n");}
	| TRUE {printf("ne_o -> TRUE\n");}
	| FALSE {printf("ne_o -> FALSE\n");}
	| L_PAREN be R_PAREN {printf("ne_o -> L_PAREN be R_PAREN\n");}
	;
	
ne: /*empty*/ {printf(" ne -> epsilon\n");}
	| NOT {printf("ne -> NOT\n");}
	;
	
res: /*empty*/ {printf("res -> epsilon\n");}
	| AND re {printf("res -> AND re\n");}
	;
	
raes: /*empty*/ {printf("raes -> epsilon\n");}
	| OR rae {printf("raes -> OR rae\n");}
	;
	
vars: var vars_ {printf("vars -> var vars_\n");};

vars_: /*empty*/ {printf("vars_ -> epsilon\n");}
	| COMMA var vars_ {printf("vars_ -> COMMA var vars_\n");}
	;

idents: IDENT idents_ {printf("idents -> IDENT idents_\n");};

idents_: /*empty*/ {printf("idents_ -> epsilon\n");}
	| COMMA IDENT idents_ {printf("idents_ -> COMMA IDENT idents_\n");}
	;
	
stmts: stmt SEMICOLON stmts_ {printf("stmts -> stmt SEMICOLON stmts_\n");};

stmts_: /*empty*/ {printf("stmts_ -> epsilon\n");}
	| stmt SEMICOLON stmts_ {printf("stmts_ -> stmt SEMICOLON stmts_\n");}
	;
	
decls: /*empty*/ {printf("decls -> epsilon\n");}
	| decl SEMICOLON decls_ {printf("decls -> decl SEMICOLON decls_\n");}
	;
	
decls_: /*empty*/ {printf("decls_ -> epsilon\n");}
	| decl SEMICOLON decls_ {printf("decls_ -> decl SEMICOLON decls_\n");}
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
