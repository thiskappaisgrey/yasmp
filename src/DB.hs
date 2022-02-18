-- The DB module contains functions for interacting with the database
module DB  where
import Database.Beam.Sqlite
import Database.SQLite.Simple
import Database.Beam
import Database.Beam.Query
import Models.User
import Models.Event
import Data.Int (Int32)
-- this Defines the Database
data YasmpDB f = YasmpDB
                      { _yasmpUsers :: f (TableEntity UserT)
                      , _yasmpEvents :: f (TableEntity EventT)
                      }
                        deriving (Generic, Database be)
yasmpDB :: DatabaseSettings be YasmpDB
yasmpDB = defaultDbSettings `withDbModification`
                  dbModification {
                    _yasmpUsers = setEntityName "users",
                    _yasmpEvents = setEntityName "events"
                  }

dbFileName = "yasmp.db"
run :: (Connection  -> IO ()) -> String -> IO ()
run statement fileName= do
  conn <- open fileName
  statement conn
  close conn
-- creates the database
createDB :: Connection -> IO ()
createDB conn = do
  execute_ conn "CREATE TABLE IF NOT EXISTS users (email VARCHAR NOT NULL, first_name VARCHAR NOT NULL, last_name VARCHAR NOT NULL, password VARCHAR NOT NULL, PRIMARY KEY( email ));"
  execute_ conn "CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR NOT NULL, description VARCHAR NOT NULL);"
-- Example queries for inserting into Users
insertUsers :: IO ()
insertUsers = do
  conn <- open dbFileName
  runBeamSqliteDebug putStrLn {- for debug output -} conn $ runInsert $
    insert (_yasmpUsers yasmpDB) $
    insertValues [ User "james@example.com" "James" "Smith" "b4cc344d25a2efe540adbf2678e2304c" {- james -}
             , User "betty@example.com" "Betty" "Jones" "82b054bd83ffad9b6cf8bdb98ce3cc2f" {- betty -}
             , User "sam@example.com" "Sam" "Taylor" "332532dcfaa1cbf61e2a266bd723612c" {- sam -} ]
  close conn

-- Example queries for inserting into Events
insertEvents :: IO ()
insertEvents = do
  conn <- open dbFileName
  runBeamSqliteDebug putStrLn {- for debug output -} conn $ runInsert $
    insert (_yasmpEvents yasmpDB) $
    -- for default values, use insertExpressions instead of insertValues
    insertExpressions [ Event default_ (val_ "Event") (val_ "some description")
                      ,  Event default_ (val_ "Another Event") (val_ "some description")]
  close conn
-- Example queries from the tutorial
queryAllUsers :: IO ()
queryAllUsers = do
  conn <- open dbFileName
  runBeamSqliteDebug putStrLn conn $ do
    users <- runSelectReturningList $ select
      $ all_ (_yasmpUsers yasmpDB) -- query for all users
    mapM_ (liftIO . print) users -- users is a List, this prints all users
  close conn
queryAllEvents :: Connection -> IO [Event]
queryAllEvents conn = do
  runBeamSqliteDebug putStrLn conn $
     runSelectReturningList $ select
      $ all_ (_yasmpEvents yasmpDB) -- query for all users

aggregateUsers :: IO ()
aggregateUsers = do
  conn <- open dbFileName
  let userCount = aggregate_ (\u -> as_ @Int32 countAll_) (all_ (_yasmpUsers yasmpDB))
  runBeamSqliteDebug putStrLn conn $ do
    Just c <- runSelectReturningOne $ select userCount
    liftIO $ putStrLn ("We have " ++ show c ++ " users in the database")
  close conn
