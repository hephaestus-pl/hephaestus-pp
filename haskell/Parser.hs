module Parser where 

import PCBasicTypes 

import Text.Parsec hiding (Line) 
import Text.Parsec.String

parseFile :: Parser [Line]
parseFile = many parseLine 

parseLine :: Parser Line
parseLine =  try (do { string "/*#";
                      skipMany1 space;  
                      exp <- many1 letter;
                      skipMany1 space; 
                      (string "*/"); 
                      return (Condition exp)
               })
         <|> do { string "/*#*/"; return EndCondition }
         <|> do { newline; return  Empty }
         <|> do { l <- many1 (noneOf "\n"); return (CodeLine l) } 
          
parseExpId :: Parser String
parseExpId = do c  <- letter 
                cs <- many alphaNum
                return (c:cs)

parseAndExp :: Parser Expression 
parseAndExp = do {
  skipMany space;
  e1 <- parseExpression; 
  skipMany1 space;
  string "and";
  skipMany1 space;
  e2 <- parseExpression;  
  return (And e1 e2)
}

parseOrExp :: Parser Expression 
parseOrExp = do {
  skipMany space;
  e1 <- parseExpression; 
  skipMany1 space;
  string "or";
  skipMany1 space;
  e2 <- parseExpression;  
  return (Or e1 e2)
}


parseNotExp :: Parser Expression 
parseNotExp = do {
  skipMany space;
  string "not";
  skipMany space; 
  e1 <- parseExpression;   
  return (Not e1)
}

parseExpression :: Parser Expression
parseExpression =  try (parseAndExp)
               <|> try (parseOrExp)
               <|> try (parseNotExp)
               <|> do { e <- parseExpId; return (ExpId e) }



run :: Show a => Parser a -> String -> IO ()
run p input = case (parse p "" input) of 
               Left err -> print err
               Right x  -> print x
