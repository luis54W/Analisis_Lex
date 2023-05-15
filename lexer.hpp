#ifndef __LEXER_HPP__
#define __LEXER_HPP__

#if !defined(yyFlexLexerOnce)
#include "lexer.ll"
#endif

#include <string>
#include <fstream>
using namespace std;

#include "Tokens.hpp"

class Lexer : public yyFlexLexer
{
public:
    Lexer(std::istream *in) : yyFlexLexer(in){        
    }
    ~Lexer() = default;
    using FlexLexer::yylex;
    virtual int yylex();
    virtual int getLine();
    virtual void error();
    virtual int getCaract();

private:    
    int line = 1;
    int caract = 1;
};
#endif // !__LEXER_HPP__
