{
{-# OPTIONS_GHC -w #-}
module BoolExprLexicalScanner (Token(..),scanTokens) where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]
$eol   = [\n]

tokens :-

  $white+                       ;
  "&&"                      	{ \s -> TokenAnd }
  "||"                      	{ \s -> TokenOr }
  \~                            { \s -> TokenNot }
  \(                            { \s -> TokenLParen }
  \)                            { \s -> TokenRParen }
  $alpha [$alpha $digit \_ \']* { \s -> TokenSym s }

{

data Token = TokenEq
           | TokenNotEq
           | TokenAnd
           | TokenOr
           | TokenNot
           | TokenLParen
           | TokenRParen
           | TokenSym String
           deriving (Eq,Show)

scanTokens = alexScanTokens

}
