module PCBasicTypes where

type Variables = [Variable]
type Variable = String

-- type Environment = (Variables, Stack)

type Stack = [Expression]

push :: Expression -> Stack -> Stack
push e []     = [e]
push e (x:xs) = (And e x) : xs

pop :: Stack -> Stack
pop [] = []
pop (x:xs) = xs 

data Line = Empty
          | Condition String
          | EndCondition
          | CodeLine String
          deriving (Show)

data Expression = And Expression Expression
                | Or Expression Expression
                | Not Expression
                | ExpId Id
   deriving(Show)

type Id = String

