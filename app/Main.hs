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
    get "/:word" $ do
      word <- param "word"
      html $ mconcat ["<h1>Hello, ", word, "!</h1>"]
