{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module DB where
import           Control.Applicative
import qualified Data.Text as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow

data Event = Event {
  id :: Int
  , name :: T.Text
  , description :: T.Text
                   }
instance Show Event where
  show (Event id name des) = mconcat ["event id: ", show id, "event name: ", show name, "event description", show des]

instance FromRow Event where
  fromRow = Event <$> field <*> field <*> field

instance ToRow Event where
  toRow (Event id_ name des) = toRow (id_, name, des)

createDB :: IO ()
createDB = do
  conn <- open "yasmp.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS event (id INTEGER PRIMARY KEY, name TEXT, description TEXT)"
  rowId <- lastInsertRowId conn
  executeNamed conn "UPDATE test SET str = :str WHERE id = :id" [":str" := ("updated str" :: T.Text), ":id" := rowId]
  r <- query_ conn "SELECT * from test" :: IO [Event]
  mapM_ print r
  execute conn "DELETE FROM test WHERE id = ?" (Only rowId)
  close conn
