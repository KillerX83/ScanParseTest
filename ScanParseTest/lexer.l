	// output file definitions
%option outfile="lexer.cpp" header-file="lexer.h"
	// 8 bit scanner for unicode processing
	// reentrant scanner
%option 8bit reentrant noyywrap

	// we are going to use stack frame for "include" feature 
%option stack

%option warn nodefault

	// to interface with bison for reentrant parser
	// and scanner
%option bison-bridge bison-locations

	// line number tracking
%option yylineno

	// with multiple flex files are used in the same project
	// to prevent name crashes
	//%option prefix="tk"

	// our own parse tree data type
%option extra-type="CParseTree*"

	// these options are for windows compatibility
%option always-interactive
%option nounistd

	// put this block at the top of the 
	// generated scanner

%top{

	// this macro definition is for windows compatibility
#define YY_NO_UNISTD_H

	#pragma warning( disable: 4005)

	#include <iostream>
	#include <cmath>
	#include <cstring>
	
	using namespace std;

	#include "parser.h"
}

INTG	[0-9]+
FLOAT	[0-9]+.[0-9]+
CHARS	[a-zA-Z]+
WS		[ \t]
CLEANSTRING ^[^#][^\n]*
%s Operator
%%

<Operator,INITIAL>{WS}+
<Operator,INITIAL>"\n" { BEGIN(INITIAL); printf("LINE %d", yylineno); return '\n'; }
<INITIAL>"#" { BEGIN(Operator); return '#'; }
<INITIAL>{CLEANSTRING} { char* a = yytext; return TKN_CleanString; }

<Operator>"," |
"("  |
"+"  |
"-"  |
"*"  |
"/"  |
"&"  |
"="  |
")" { return yytext[0];}

<Operator>"def" { return TKN_def; }
<Operator>"read" { return TKN_read; }
<Operator>"for" { return TKN_for; }
<Operator>"to" { return TKN_to; }
<Operator>"next" { return TKN_next; }
<Operator>"int" {return TKN_type; }
<Operator>"real" {return TKN_type; }

<Operator>{CHARS}+ { return TKN_identifier; }
<Operator>{INTG}+	{ return TKN_constant; }
<Operator>{FLOAT}+ { return TKN_constant; }




%%
