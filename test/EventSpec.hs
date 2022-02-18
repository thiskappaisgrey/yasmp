{-# LANGUAGE OverloadedStrings #-}

module EventSpec (spec) where

import Models.Event
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.Internal
import Data.Aeson
import Util
import Database.Beam.Sqlite
import Database.Beam.Query
import Database.SQLite.Simple
import DB

event :: Event
event =
  Event
    { _eventId = 0,
      _eventName = "Some event",
      _eventDescription = "Description"
    }

spec :: Spec
spec = aroundAll withDatabaseConnection $ do
  describe "POST /events" $ do
    it "should create an event in the database" $ \c -> do
      app <- mkApplication c
      withApplication app $ do
        post "/events" (encode event) `shouldRespondWith` 200
      events <- queryAllEvents c
      let e = (head events) {_eventId  = 0}
      e `shouldBe` event
