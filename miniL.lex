   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
	int pos = 1;
	int my_yylineno = 1;
%}
   /* some common rules */

LETTER				[a-zA-Z]
DIGIT				[0-9]
ID					[a-zA-Z][_a-zA-Z0-9]*[a-zA-Z0-9]
NUM					[0-9]+
INV					()|({ID}_)|

%%
   /* specific lexer rules in regex */

function			{pos += yyleng; printf("FUNCTION\n");}
beginparams			{pos += yyleng; printf("BEGIN_PARAMS\n");}
endparams			{pos += yyleng; printf("END_PARAMS\n");}
beginlocals			{pos += yyleng; printf("BEGIN_LOCALS\n");}
endlocals			{pos += yyleng; printf("END_LOCALS\n");}
beginbody			{pos += yyleng; printf("END_BODY\n");}
integer				{pos += yyleng; printf("INTEGER\n");}
array				{pos += yyleng; printf("ARRAY\n");}
enum				{pos += yyleng; printf("ENUM\n");}
of					{pos += yyleng; printf("OF\n");}
if					{pos += yyleng; printf("IF\n");}
then				{pos += yyleng; printf("THEN\n");}
endif				{pos += yyleng; printf("ENDIF\n");}
else				{pos += yyleng; printf("ELSE\n");}
for					{pos += yyleng; printf("FOR\n");}
while				{pos += yyleng; printf("WHILE\n");}
do					{pos += yyleng; printf("DO\n");}
beginloop			{pos += yyleng; printf("BEGINLOOP\n");}
endloop				{pos += yyleng; printf("ENDLOOP\n");}
continue			{pos += yyleng; printf("CONTINUE\n");}
read				{pos += yyleng; printf("READ\n");}
write				{pos += yyleng; printf("WRITE\n");}
and					{pos += yyleng; printf("AND\n");}
or					{pos += yyleng; printf("OR\n");}
not					{pos += yyleng; printf("NOT\n");}
true				{pos += yyleng; printf("TRUE\n");}
false				{pos += yyleng; printf("FALSE\n");}
return				{pos += yyleng; printf("RETURN\n");}

"-"					{pos += yyleng; printf("SUB\n");}
"+"					{pos += yyleng; printf("ADD\n");}
"*"					{pos += yyleng; printf("MULT\n");}
"/"					{pos += yyleng; printf("DIV\n");}
"%"					{pos += yyleng; printf("MOD\n");}

"=="				{pos += yyleng; printf("EQ\n");}
"<>"				{pos += yyleng; printf("NEQ\n");}
"<"					{pos += yyleng; printf("LT\n");}
">"					{pos += yyleng; printf("GT\n");}
"<="				{pos += yyleng; printf("LTE\n");}
">="				{pos += yyleng; printf("GTE\n");}

";"					{pos += yyleng; printf("SEMICOLON\n");}	
":"					{pos += yyleng; printf("COLON\n");}
","					{pos += yyleng; printf("COMMA\n");}
"("					{pos += yyleng; printf("L_PAREN\n");}
")"					{pos += yyleng; printf("R_PAREN\n");}
"["					{pos += yyleng; printf("L_SQUARE_BRACKET\n");}
"]"					{pos += yyleng; printf("R_SQUARE_BRACKET\n");}
":="				{pos += yyleng; printf("ASSIGN\n");}

{ID}				{pos += yyleng; printf("IDENT %s\n", yytext);}
{NUM}				{pos += yyleng; printf("NUMBER %s\n", yytext);}

[{DIGIT}_]{ID}		{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",my_yylineno, pos, yytext); return 1;}
{ID}_				{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",my_yylineno, pos, yytext); return 1;}


##.*\n				{my_yylineno++; pos = 1; /**/}
[ \t]+				{pos += yyleng; /**/}
\n					{my_yylineno++; pos = 1;/**/}

.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",my_yylineno, pos, yytext); return 1;}

%%
	/* C functions used in lexer */
int main(int argc, char ** argv)
{
	int i;
	if(argc < 2){
		my_yylineno = 1;
		yylex();
	}
	else{
		for(i = 1; i < argc; i++){
			FILE* f = fopen(argv[i], "r");
			
			if(!f){
				perror(argv[1]);
				return 1;
			}
			
			yyrestart(f);
			my_yylineno = 1;
			yylex();
			fclose(f);
		}
	}
}
