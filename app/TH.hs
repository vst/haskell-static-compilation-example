{-# LANGUAGE TemplateHaskellQuotes #-}

module TH where

import Language.Haskell.TH ( Exp, Q )


the42 :: Int
the42 = 42


static42 :: Q Exp
static42 = [| the42 |]
