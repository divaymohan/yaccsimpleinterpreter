%{
void yyerror(char *s);
#include<stdio.h>
#include<stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolval(char symbol,int val);
%}
%union {int num; char id;}
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

line : assignment ';'  {;}
	| exit_command ';' {exit(EXIT_SUCCESS);}
	|print exp ';' {printf("printing  %d\n",$2);}
	|line assignment ';' {;}
	|line print exp ';' {printf("printing  %d\n",$3);}
	|line exit_command ';' {exit(EXIT_SUCCESS);}
	;
	
assignment : identifier '=' exp  {updateSymbolval($1,$3);}
             ;
exp : term {$$=$1;}
	|exp '+' term {$$=$1+$3;}
	|exp '-' term {$$=$1-$3;}
	|exp '*' term {$$=$1*$3;}
	|exp '/' term {$$=$1/$3;}
	;
	
term : number {$$=$1;}
	| identifier {$$=symbolVal($1);}
	;
	
%%

int computeindex(char token){
	int idx=-1;
	if(islower(token)){
		idx=(int)token-(int)'a'+26;
	}
	else if(isupper(token)){
		idx=(int)token-'A';
	}
	return idx;
}
int symbolVal(char symbol){
	int bucket = computeindex(symbol);
	return symbols[bucket];
}
void updateSymbolval(char symbol,int val){
	int bucket = computeindex(symbol);
	symbols[bucket]=val;
}
int main(void){
	int i;
	for(i=0;i<52;i++){
		symbols[i]=0;
	}
	return yyparse();
}

void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}
