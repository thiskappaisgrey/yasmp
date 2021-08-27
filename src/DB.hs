module DB where
import Database.Beam.Sqlite
import Database.SQLite.Simple
import Database.Beam
import Models.User
import Data.Int (Int32)
-- this Defines the Database
newtype YasmpDB f = YasmpDB
                      { _yasmpUsers :: f (TableEntity UserT) }
                        deriving (Generic, Database be)
yasmpDB :: DatabaseSettings be YasmpDB
yasmpDB = defaultDbSettings

dbFileName = "yasmp.db"

-- creates the database
createDB :: IO ()
createDB = do
  conn <- open "shoppingcart.db"
  execute_ conn "CREATE TABLE users (email VARCHAR NOT NULL, first_name VARCHAR NOT NULL, last_name VARCHAR NOT NULL, password VARCHAR NOT NULL, PRIMARY KEY( email ));"
  close conn
populateDB :: IO ()
populateDB = do
  conn <- open "shoppingcart.db"
  runBeamSqliteDebug putStrLn {- for debug output -} conn $ runInsert $
    insert (_yasmpUsers yasmpDB) $
    insertValues [ User "james@example.com" "James" "Smith" "b4cc344d25a2efe540adbf2678e2304c" {- james -}
             , User "betty@example.com" "Betty" "Jones" "82b054bd83ffad9b6cf8bdb98ce3cc2f" {- betty -}
             , User "sam@example.com" "Sam" "Taylor" "332532dcfaa1cbf61e2a266bd723612c" {- sam -} ]
  close conn
queryAllUsers :: IO ()
queryAllUsers = do
  conn <- open "shoppingcart.db"
  runBeamSqliteDebug putStrLn conn $ do
    users <- runSelectReturningList $ select
      $ all_ (_yasmpUsers yasmpDB) -- query for all users
    mapM_ (liftIO . print) users -- users is a List, this prints all users
  close conn
aggregateUsers :: IO ()
aggregateUsers = do
  conn <- open "shoppingcart.db"
  let userCount = aggregate_ (\u -> as_ @Int32 countAll_) (all_ (_yasmpUsers yasmpDB))
  runBeamSqliteDebug putStrLn conn $ do
    Just c <- runSelectReturningOne $ select userCount
    liftIO $ putStrLn ("We have " ++ show c ++ " users in the database")
  close conn
