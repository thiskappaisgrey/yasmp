module Models.User where
import Database.Beam
import Data.Text (Text)
-- using beam depends on language extensions I enabled in the cabal file for convenience
-- TODO Figure out how to use an autoincrementing primarykey in the database.
-- TODO Create an Events table, the Tags table, and TagsToEventsRelation Table
data UserT f
    = User
    { _userEmail     :: Columnar f Text
    , _userFirstName :: Columnar f Text
    , _userLastName  :: Columnar f Text
    , _userPassword  :: Columnar f Text }
    deriving (Generic, Beamable)
instance Table UserT where
   data PrimaryKey UserT f = UserId (Columnar f Text) deriving (Generic, Beamable)
   primaryKey = UserId . _userEmail

-- A type with a higher kind, for example, (* -> *) can be thought of as a kind of function
-- Identity type is a higher-kinded (* -> *) type such that (Identity a) = (a), where a is a type
-- This technique is called defunctionalization or highter-kinded data types
type User = UserT Identity --  (User @Identity) :: Text -> Text -> Text -> Text -> UserT Identity
deriving instance Show User -- uses the extensions StandaloneDeriving and TypeSynonymInstances to derive from the type synonym
deriving instance Eq User
type UserId = PrimaryKey UserT Identity
