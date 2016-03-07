{
module BoolExprSintaticScanner (parseFunction) where

import BoolExprLexicalScanner
import PCBasicTypes

}

%name expr
%tokentype { Token }
%error { parseError }

%token
    and   { TokenAnd }
    or    { TokenOr }
    not   { TokenNot }
    '('   { TokenLParen }
    ')'   { TokenRParen }
    var   { TokenSym $$ }

%%

Expr :	Expr and Expr                 { And $1 $3 }
      | Expr or Expr                  { Or $1 $3 }
      | not Expr                      { Not $2 }
      | '(' Expr ')'                  { $2 }
      | var                           { ExpId $1 }

{

parseError :: [Token] -> a
parseError _ = error "Expression parse error"

parseFunction :: String -> Expression
parseFunction = expr . scanTokens

}
