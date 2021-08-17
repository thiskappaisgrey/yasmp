{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Monoid (mconcat)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import qualified Text.Blaze.Html5 as H

homepage :: H.Html
homepage = H.html $
          H.body $ do
            H.h1 "Yasmp - Yet Another Social Media Platform"

main :: IO ()
main =
  scotty 3000 $ do
    get "/" $
      html $ renderHtml homepage
    get "/events/:event" $ do
      event <- param "event"
      html $ mconcat ["<h1>Hello, ", event, "!</h1>"]
    get "/events" $ do
      html $ mconcat ["<h1>Events ",  "!</h1>"]
    post "/events" $ do
      event <- param "event"
      html $ mconcat ["<h1>Event, ", event, "!</h1>"]
