{-# LANGUAGE TemplateHaskell #-}

module Main where

import TH (static42)


main :: IO ()
main = putStrLn $ "Hello, Haskell! It is " <> show $static42 <> "."
