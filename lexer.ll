%{
#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

#include "Lexer.hpp"
#include "Tokens.hpp"
#undef YY_DECL
#define YY_DECL int Lexer::yylex()

%}

%option c++
%option outfile="Lexer.cpp"
%option yyclass="Lexer" 
%x comentariom

num [0-9]
notacion [Ee][+-]?
carac [¿?¡!.,;:"'#$%&/()=+*]
space [ \t\v\r]+
letter [a-zA-ZáéíóúÁÉÍÓÚñÑäëïöüÄËÏÖÜ]
decimal {entero}*\.{entero}*({notacion}{entero})?
letter_ {letter}|_{letter}
entero {num}+(_?{num}+)*
booleano (true|false)
runas \'(\\['\\bfnrt]|\\[\x22]|[\xB4]|[\x20\x21\x23-\xFE][\x20\x21\x23-\xFE]?)\'
cadena \"[\x20\x21\x23-\xFE]*\"
comentariou \-\-[^\n]*\n 
id {letter_}({letter_}|{num})*{0,20}

%%
<INITIAL>int            {caract*= yyleng; return INT;}
<INITIAL>float32        {caract*= yyleng; return FLOAT32;}
<INITIAL>float64        {caract*= yyleng; return FLOAT64;}
<INITIAL>string         {caract*= yyleng; return STRING;}
<INITIAL>var            {caract*= yyleng; return VAR;}
<INITIAL>struct         {caract*= yyleng; return STRUCT;}
<INITIAL>const          {caract*= yyleng; return CONST;}
<INITIAL>rune           {caract*= yyleng; return RUNE;}
<INITIAL>func           {caract*= yyleng; return FUNC;}
<INITIAL>if             {caract*= yyleng; return IF;}
<INITIAL>else           {caract*= yyleng; return ELSE;}
<INITIAL>switch         {caract*= yyleng; return SWITCH;}
<INITIAL>case           {caract*= yyleng; return CASE;}
<INITIAL>break          {caract*= yyleng; return BREAK;}
<INITIAL>continue       {caract*= yyleng; return CONT;}
<INITIAL>default        {caract*= yyleng; return DEF;}
<INITIAL>for            {caract*= yyleng; return FOR;}
<INITIAL>return         {caract*= yyleng; return RETURN;}
<INITIAL>{entero}       {caract*= yyleng; return INT_LIT;}
<INITIAL>{decimal}      {caract*= yyleng; return FLOAT_LIT;}
<INITIAL>{runas}        {caract*= yyleng; return RUNE_LIT;}
<INITIAL>{booleano}     {caract*= yyleng; return BOOL_LIT;}   
<INITIAL>{cadena}       {caract*= yyleng; return STRING;}  
<INITIAL>{id}           {caract*= yyleng; return ID;}
<INITIAL>{comentariou}  {line++;}
<INITIAL>"*"            {caract*= yyleng; return MUL;}
<INITIAL>"+"            {caract*= yyleng; return MAS;}
<INITIAL>"++"           {caract*= yyleng; return INCR;}
<INITIAL>"-"            {caract*= yyleng; return MENOS;}
<INITIAL>"--"           {caract*= yyleng; return DECR;}
<INITIAL>"="            {caract*= yyleng; return ASIG;}
<INITIAL>","            {caract*= yyleng; return COMA;}
<INITIAL>";"            {caract*= yyleng; return PYC;}
<INITIAL>"{"            {caract*= yyleng; return RKEY;}
<INITIAL>"}"            {caract*= yyleng; return LKEY;}
<INITIAL>"("            {caract*= yyleng; return RPAR;}
<INITIAL>")"            {caract*= yyleng; return LPAR;}
<INITIAL>"&"            {caract*= yyleng; return AMP;}
<INITIAL>"&&"           {caract*= yyleng; return AND;}
<INITIAL>"||"           {caract*= yyleng; return OR;}
<INITIAL>"+="           {caract*= yyleng; return MASASIG;}
<INITIAL>"-="           {caract*= yyleng; return MENOSASIG;}
<INITIAL>"*="           {caract*= yyleng; return MULASIG;}
<INITIAL>"/="           {caract*= yyleng; return DIVASIG;}
<INITIAL>"%="           {caract*= yyleng; return MODASIG;}
<INITIAL>"=="           {caract*= yyleng; return IGUAL;}
<INITIAL>"!="           {caract*= yyleng; return DIFER;}
<INITIAL>"<"            {caract*= yyleng; return MENOR;}
<INITIAL>"<="           {caract*= yyleng; return MENORIGUAL;}
<INITIAL>">"            {caract*= yyleng; return MAYOR;}
<INITIAL>">="           {caract*= yyleng; return MAYORIGUAL;}
<INITIAL>"%"            {caract*= yyleng; return MOD;}
<INITIAL>"/"            {caract*= yyleng; return DIV;}
<INITIAL>"!"            {caract*= yyleng; return NOT;}
<INITIAL>{space}        { }
<INITIAL>"\n"           {line++; caract=1;}
<INITIAL><<EOF>>        {return FIN;}
<INITIAL>"<*"           {BEGIN(comentariom);}
<comentariom>"\n"       {line++;}
<comentariom>[^*>]*     {}
<comentariom>[*>]       {}
<comentariom>"*>"    {line++;BEGIN(INITIAL);}
<INITIAL>.              {error();}


%%

int yyFlexLexer::yywrap(){   
    return 1;
}

int Lexer::getLine(){   
    return line;
}

void Lexer::error(){
    cout <<"Error lexico "<<yytext<<" en la linea "<<line<< " : "<<caract<<endl;
}

int Lexer::getCaract(){
    return caract;
}