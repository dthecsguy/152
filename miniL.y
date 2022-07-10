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
%right UMINUS
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN

%token <d> NUMBER
%token <s> IDENT

%%
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
