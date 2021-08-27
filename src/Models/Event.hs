-- |
module Models.Event where
import Database.Beam
import Data.Text (Text)
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
type AddressId = PrimaryKey AddressT Identity -- For convenience

-- A type with a higher kind, for example, (* -> *) can be thought of as a kind of function
-- Identity type is a higher-kinded (* -> *) type such that (Identity a) = (a), where a is a type
-- This technique is called defunctionalization or highter-kinded data types
type Event = EventT Identity --  (Event @Identity) :: Text -> Text -> Text -> Text -> EventT Identity
deriving instance Show Event -- uses the extensions StandaloneDeriving and TypeSynonymInstances to derive from the type synonym
deriving instance Eq Event
type EventId = PrimaryKey EventT Identity
