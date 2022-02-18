{-# LANGUAGE ScopedTypeVariables #-}
-- |
module Actions.Event where
import DB (yasmpDB, dbFileName, _yasmpEvents)
import Database.Beam
import Database.Beam.Query
import Database.SQLite.Simple
import Models.Event
import Database.Beam.Sqlite
import Web.Scotty

postEvent :: Connection  -> ScottyM ()
postEvent conn = post "/events" $ do
             event :: Event <- jsonData
             let name = _eventName event
             let description = _eventDescription event
             liftIO $ runBeamSqliteDebug putStrLn {- for debug output -} conn $ runInsert $
               -- don't know of a better way to do it...
                insert (_yasmpEvents yasmpDB) $ insertExpressions [Event default_ (val_ name) (val_ description)]

             Web.Scotty.json event
