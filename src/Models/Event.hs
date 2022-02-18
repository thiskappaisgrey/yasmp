{-# LANGUAGE RecordWildCards #-}
-- |
module Models.Event where
import Database.Beam
import Data.Text (Text)
import Data.Int
import Data.Aeson
import Data.Maybe (fromMaybe)

data EventT f
    = Event
    { _eventId     :: C f Int32
    , _eventName :: C f Text
    , _eventDescription  :: C f Text
    -- TODO add event tags, and figure out the best datastructure
     }
    deriving (Generic, Beamable)

instance Table EventT where
  data PrimaryKey EventT f = EventT (Columnar f Int32) deriving (Generic, Beamable)
  primaryKey = EventT . _eventId
type Event = EventT Identity
deriving instance Show Event
deriving instance Eq Event
type EventId = PrimaryKey EventT Identity

instance FromJSON Event where
  parseJSON = withObject "Event" $ \v -> do
        idMaybe <- v .:? "id"
        name <- v .: "name"
        des <- v .: "description"
        -- event id is optional
        let id = fromMaybe 0 idMaybe
        return (Event id name des)

instance ToJSON Event where
  toJSON Event {..} = object [
    "name" .= _eventName
    , "id" .= _eventId
    , "description" .= _eventDescription
                             ]
