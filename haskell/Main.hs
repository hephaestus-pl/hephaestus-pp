module Main where 

import System.IO
import System.Environment 
import Control.Exception 

import PlasmaCutter 

main = do 
  args <- getArgs
  case args of 
   [f, e] -> do pf <- readFile f
                ef <- readFile e 
                let files = lines pf
                let env   =  lines ef
                preprocessFiles files env
   otherwise -> putStr "nok" 

preprocessFiles [] env = putStr "Done!" 
preprocessFiles (f:fs) env = do 
  aFile <- readFile f 
  let content = lines aFile
  putStr $ show content
  res <- extractCode content [] env
  bracket (openFile (f ++ "bak") WriteMode)
          hClose
          (\h -> hPutStr h (unlines res))
