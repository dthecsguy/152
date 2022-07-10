   /* cs152-miniL phase2 */

%option noyywrap

%{   
   /* write your C code here for definitions of variables and including headers */
	int pos = 1;
	int my_yylineno = 1;
%}

/* some common rules */

LETTER				([a-zA-Z])
DIGIT				([0-9])
ID					([a-zA-Z]+(_+[a-zA-Z0-9]+)*)
NUM					([0-9]+)

%%
   /* specific lexer rules in regex */

function			{pos += yyleng; return("FUNCTION");}
beginparams			{pos += yyleng; return("BEGIN_PARAMS");}
endparams			{pos += yyleng; return("END_PARAMS");}
beginlocals			{pos += yyleng; return("BEGIN_LOCALS");}
endlocals			{pos += yyleng; return("END_LOCALS");}
beginbody			{pos += yyleng; return("BEGIN_BODY");}
endbody				{pos += yyleng; return("END_BODY");}
integer				{pos += yyleng; return("INTEGER");}
array				{pos += yyleng; return("ARRAY");}
enum				{pos += yyleng; return("ENUM");}
of					{pos += yyleng; return("OF");}
if					{pos += yyleng; return("IF");}
then				{pos += yyleng; return("THEN");}
endif				{pos += yyleng; return("ENDIF");}
else				{pos += yyleng; return("ELSE");}
for					{pos += yyleng; return("FOR");}
while				{pos += yyleng; return("WHILE");}
do					{pos += yyleng; return("DO");}
beginloop			{pos += yyleng; return("BEGINLOOP");}
endloop				{pos += yyleng; return("ENDLOOP");}
continue			{pos += yyleng; return("CONTINUE");}
read				{pos += yyleng; return("READ");}
write				{pos += yyleng; return("WRITE");}
and					{pos += yyleng; return("AND");}
or					{pos += yyleng; return("OR");}
not					{pos += yyleng; return("NOT");}
true				{pos += yyleng; return("TRUE");}
false				{pos += yyleng; return("FALSE");}
return				{pos += yyleng; return("RETURN");}

"-"					{pos += yyleng; return('-');}
"+"					{pos += yyleng; return('+');}
"*"					{pos += yyleng; return('*');}
"/"					{pos += yyleng; return('/');}
"%"					{pos += yyleng; return('%');}

"=="				{pos += yyleng; return("EQ");}
"<>"				{pos += yyleng; return("NEQ");}
"<"					{pos += yyleng; return("LT");}
">"					{pos += yyleng; return("GT");}
"<="				{pos += yyleng; return("LTE");}
">="				{pos += yyleng; return("GTE");}

";"					{pos += yyleng; return("SEMICOLON");}	
":"					{pos += yyleng; return("COLON");}
","					{pos += yyleng; return("COMMA");}
"("					{pos += yyleng; return("L_PAREN");}
")"					{pos += yyleng; return("R_PAREN");}
"["					{pos += yyleng; return("L_SQUARE_BRACKET");}
"]"					{pos += yyleng; return("R_SQUARE_BRACKET");}
":="				{pos += yyleng; return("ASSIGN");}

{ID}				{pos += yyleng; yylval.s = yytext; return("IDENT");}
{NUM}				{pos += yyleng; yylval.d = atoi(yytext); return("NUMBER");}

[{DIGIT}_]{ID}		{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",my_yylineno, pos, yytext); return 1;}
{ID}_				{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",my_yylineno, pos, yytext); return 1;}


##.*\n				{my_yylineno++; pos = 1; /**/}
[ \t]+				{pos += yyleng; /**/}
\n					{my_yylineno++; pos = 1;/**/}

.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",my_yylineno, pos, yytext); return 1;}

%%
