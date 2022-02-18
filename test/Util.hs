-- |
{-# LANGUAGE OverloadedStrings#-}
module Util where
import Database.SQLite.Simple
import Network.Wai (Application)
import Lib
import Web.Scotty (scottyApp)
import DB (createDB)
import Control.Exception.Base (bracket)

mkApplication :: Connection -> IO Application
mkApplication conn = scottyApp $ Lib.app conn
openConnection :: IO Connection
openConnection = do
  conn <- open "test.db"
  createDB conn
  execute_ conn "BEGIN TRANSACTION;"
  return conn

closeConnection :: Connection -> IO ()
closeConnection conn = do
  execute_ conn "ROLLBACK;"
  close conn

withDatabaseConnection ::  (Connection -> IO ()) -> IO ()
withDatabaseConnection = bracket openConnection closeConnection
