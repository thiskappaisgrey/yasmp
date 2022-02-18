{-# LANGUAGE DoAndIfThenElse #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
module Lib (acceptHtml, app) where
import qualified Data.Text as T
import qualified Data.Text.Lazy as TZ
import Web.Scotty
import Pages
import Database.SQLite.Simple
import DB
import Actions.Event (postEvent)
import Lucid.Base (renderText)

-- TODO Add some form of database by either using sqlite-simple(then transitioning to postgres if I can set it up) or for the funsies learn to use STM
acceptHtml :: Maybe TZ.Text -> Bool
acceptHtml Nothing = False
acceptHtml (Just t) =
  let acceptHeaders = TZ.splitOn "," t
   in "text/html" `elem` acceptHeaders
-- pull out the database connection for testing purposes
app :: Connection -> ScottyM ()
app conn = do
  get "/" $ do
      accept <- header "Accept"
      -- returns html when the requestor asks for it
      if acceptHtml accept then
        html $ renderText homepage
      else
        text "hello"
  postEvent conn
  get "/events/:event" $ do
      event <- param "event"
      html $ renderText $ eventPage event
  get "/events" $ do
      html $ mconcat ["<h1>Events ", "!</h1>"]
  post "/events" $ do
      event <- param "event"
      html $ mconcat ["<h1>Event, ", event, "!</h1>"]
