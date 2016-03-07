{
module LineSintaticScanner (parseLine) where

import LineLexicalScanner
import PCBasicTypes

}

%name expr
%tokentype { Token }
%error { parseError }

%token
    empty   { EmptyLine }
    commBeg { TokenCommentBegin }
    commEnd { TokenCommentEnd }
    plasma  { TokenPlasmaCutter }
    text    { TokenText $$ } 

%%

Line:   commBeg plasma text commEnd     { Condition $3 }
      | commBeg plasma commEnd          { EndCondition }      
      | text                            { CodeLine $1 }
      | empty                           { Empty }
      | list(Element)                   { CodeLine (foldl (++) [] $1) }

Element: commBeg                        { "/*" }
       | commEnd                        { "*/" }
       | plasma                         { "#" }
       | text                           { $1 }

list(p):p				{ [$1] }
	| p list(p)			{ $1 : $2 }

{

parseError :: [Token] -> a
parseError _ = error "Line parse error"

parseLine :: String -> Line
parseLine = expr . scanTokens

}
