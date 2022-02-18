{-# LANGUAGE OverloadedStrings #-}
module Main where
import qualified Lib
import Web.Scotty
import Database.SQLite.Simple

main :: IO ()
main = do
  conn <- open "yasmp.db"
  scotty 3000 (Lib.app conn)
