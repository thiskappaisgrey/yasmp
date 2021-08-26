{-# LANGUAGE ExtendedDefaultRules, OverloadedStrings #-}
module Pages where
import Lucid.Base
import Lucid.Html5
import qualified Data.Text as T

homepage :: Html ()
homepage = body_ $ do
  h1_ "Yasmp - Yet Another Social Media Platform"

eventPage :: T.Text -> Html ()
eventPage event = body_ $ h1_ $ toHtml $ mconcat ["Events are: ", event]
