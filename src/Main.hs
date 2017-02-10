{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import qualified Language.C.Inline as C
import qualified Data.Vector.Storable as V
import qualified Data.Vector.Storable.Mutable as VM
import           Data.Monoid ((<>))
import           Foreign.C.Types

C.context (C.baseCtx <> C.vecCtx)
C.include "<math.h>"

sumVec :: VM.IOVector CDouble -> IO CDouble
sumVec vec =
  [C.block| double {
    double sum = 0;
    int i;
    for (i = 0; i < $vec-len:vec; i++) {
      sum += $vec-ptr:(double *vec)[i];
    }
    return sum;
  } |]

main :: IO ()
main = do
  x <- [C.exp| double{ cos(1.0) } |]
  print $ "cos(1.0) = " ++ show x
  x <- sumVec =<< V.thaw (V.fromList [1,2,3])
  print x
