module PlasmaCutter where

import Text.Parsec hiding (Line)
import Text.Parsec.String 

import PCBasicTypes

-- import LineSintaticScanner
-- import BoolExprSintaticScanner

import Parser 

--extractCode :: [String] -> Stack -> Variables ->  Parser [String]
extractCode [] s _ = return []
extractCode (x:xs) s env = 
  case (parse parseLine "" x) of 
    Left e   ->  do  r <- extractCode xs s env
                     return r

    Right v  ->  do res1 <- extractLine v s env 
                    let r1  = snd res1
                    let ns = fst res1
                    r2 <- extractCode xs ns env  
                    return (r1 ++ r2)

--extractLine :: Line -> Stack -> Variables -> Parser (Stack, [String])

extractLine (Condition e) s _ = 
 case (parse parseExpression "" e) of 
   Left  e    -> return (s, [])
   Right exp  -> return (push exp s, [])

extractLine EndCondition s _ = return (pop s, [])

extractLine (CodeLine l) [] env = return ([], [l])
extractLine (CodeLine l) s@(x:xs) env = 
 if(evalFunction env x) 
   then return (s, [l]) 
   else return (s, [])

extractLine Empty [] env = return ([], ["\n"])
extractLine Empty s@(x:xs) env = 
 if(evalFunction env x) 
   then return (s, ["\n"]) 
   else return (s, []) 



-- evaluateCondition :: String -> Variables -> Bool
-- evaluateCondition fun env = evalFunction env $ parseExpression fun

evalFunction :: Variables -> Expression -> Bool
evalFunction env (And lhs rhs) = (evalFunction env lhs) && (evalFunction env rhs)
evalFunction env (Or lhs rhs) = (evalFunction env lhs) || (evalFunction env rhs)
evalFunction env (Not exp) = not (evalFunction env exp)
evalFunction env (ExpId var) = elem var env 
--  let exp = [x | x <- env, var == x] 
--  in case exp of 
--       []  -> False
--       _ -> True
