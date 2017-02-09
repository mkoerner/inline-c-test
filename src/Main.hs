{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import qualified Language.C.Inline as C

C.include "<math.h>"

main :: IO ()
main = do
  x <- [C.exp| double{ cos(1.0) } |]
  print $ "cos(1.0) = " ++ show x

