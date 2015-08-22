{-# LANGUAGE DeriveAnyClass, DeriveGeneric #-}

module Main where

import Control.DeepSeq
import Data.Binary
import qualified Data.ByteString.Lazy as LBS
import System.Random

import GHC.Generics

import Criterion.Main

data Tree a = Leaf a | Branch (Tree a) (Tree a)
  deriving (Generic, Show, NFData, Binary)

data Tree1 a = Leaf1 a | Branch1 (Tree1 a) (Tree1 a)
  deriving (Show)

generateRandomTree :: Int -> IO (Tree Int)
generateRandomTree 0 = Leaf   <$> randomIO
generateRandomTree n = Branch <$> generateRandomTree (n-1) <*> generateRandomTree (n-1)

generateRandomTree1 :: Int -> IO (Tree1 Int)
generateRandomTree1 0 = Leaf1   <$> randomIO
generateRandomTree1 n = Branch1 <$> generateRandomTree1 (n-1) <*> generateRandomTree1 (n-1)

instance NFData a => NFData (Tree1 a) where
  rnf (Leaf1 a) = rnf a
  rnf (Branch1 t1 t2) = rnf t1 `seq` rnf t2

instance Binary a => Binary (Tree1 a) where
  put (Leaf1 a) = putWord8 0 >> put a
  put (Branch1 t1 t2) = putWord8 1 >> put t1 >> put t2

  get = do
    w <- getWord8
    case w of
      0 -> Leaf1 <$> get
      1 -> Branch1 <$> get <*> get
      _ -> fail "get for Tree1: encoding or decoding error"

size :: Int
size = 20

main :: IO ()
main =
    defaultMain
      [ env (generateRandomTree size) $ \tree ->
          bgroup "Generic"
            [ bench "NFData" $ whnf force tree
            , bench "Binary" $ whnf (LBS.toStrict . encode) tree
            ]
      , env (generateRandomTree1 size) $ \tree ->
          bgroup "Hand-written"
            [ bench "NFData" $ whnf force tree
            , bench "Binary" $ whnf (LBS.toStrict . encode) tree
            ]
      ]
