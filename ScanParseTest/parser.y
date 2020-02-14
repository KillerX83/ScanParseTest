	// generate header file
%defines "parser.h"

	// the parser implementation file name
%output "parser.cpp"

	// for location tracking support
%locations



	// Enable run-time trace
%define parse.trace

	// for reentrant parser
%define api.pure full

	// when multiple parsers' are used
	// not for this tutorial
	//%define api.prefix {tk}

	// provides verbose error messages
	// about syntax error
 %define parse.error verbose

	// yylex scanner interface
	// this is a must-have for re-entrant scanner 
%param	{yyscan_t scanner}

	// for interaction with my own C++ class
%parse-param	{CParseTree* pParseTree}

	// place this code at the top of 
	// generated bison implementation file, i.e., parser.cpp
%code requires
{
	#pragma warning (disable: 4005)

	#include <iostream>
	#include <cstdio>
	#include "ParseTree.h"
		
	using namespace std;

	typedef void* yyscan_t;


}

	// this code block is used for declaration type and functions
	// that requires YYSTYPE, the symantic type
%code {
	
	typedef void* yyscan_t;

	extern int yylex(YYSTYPE*, YYLTYPE*, yyscan_t);

	void yyerror (YYLTYPE*, yyscan_t yyscanner, CParseTree* pParseTree, const char*);
}

%initial-action
{
	/* code for initialization before parsing 
		code in this block is executed each time yyparse is called. */

		yydebug = 1;
}

	// we are going to use
	// bison's newer semantic data type definitions
	// %define api.value.type union
%union
{	
	int intg;
	char* cstr;
	double dbl;
	enum class TYPE { INTG=0, DBL} ;
}
	// attach TKN_ prefix to the user defined 
	// token type
%define api.token.prefix {TKN_}

%token	DEBUG_ON DEBUG_OFF
%token '#' '&'  ',' '\n' 
%token CleanString for next to read def
%token  identifier
%token constant
%token  type
%right '='
%left '+' '-'
%left '*' '/'

	

%start program

%%

program: %empty
	| program statement 
	;
	
statement: '#' for identifier '=' expression to expression '\n' list  '\n'
	| '#' def DefOp '\n' 
	| '#' read ReadOp '\n' 
	| CleanString '\n'
	| '\n'
	;

DefOp: variable type 
	| variable type ',' DefOp 
	;

ReadOp: variable 
	| variable ',' ReadOp 
	;

expression: constant	
	| variable		
	| expression '+' expression 
	| expression '-' expression	
	| expression '*' expression	
	| expression '/' expression	
	| '(' expression ')'		
	;

list: '#' next identifier
	| statement list 
	;

variable: identifier 
	| identifier '(' expression ')'
	| identifier '(' expression ',' expression ')' 
	;


%%

// newer yyerror() function definition
// for use with reentant scanner and parser
// with location tracking
void yyerror (YYLTYPE *yylloc, yyscan_t yyscanner,
	 CParseTree* pParseTree, const char* msg)
{
	std::cout<<"Error - "<<msg<<std::endl;
}