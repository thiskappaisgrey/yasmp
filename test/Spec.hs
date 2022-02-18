{-# LANGUAGE OverloadedStrings#-}
module Main where
import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Data.Text.Lazy as T
import Test.QuickCheck.Instances.Text 
import Lib
import qualified EventSpec
-- generates a list of values that inclues the item "text/html"
htmlGen :: Gen (Maybe T.Text)
htmlGen = do
  list <- listOf1 (arbitrary :: Gen Text)
  randomList <- shuffle $ pack "text/html":list
  return $ Just . T.intercalate "," $ randomList
-- generates a list of values that doesn't inclues the item "text/html"
htmlGenFalse :: Gen (Maybe T.Text)
htmlGenFalse = do
  list <- listOf1 (arbitrary :: Gen Text)
  return $ Just . T.intercalate "," $ list

htmlProp x = forAll htmlGen acceptHtml
htmlPropFalse x = forAll htmlGenFalse (not . acceptHtml)


main :: IO ()
main = hspec $ do
  describe "Lib.acceptHtml" $ do
    it "Returns false when the text given is a nothing" $
      acceptHtml Nothing  `shouldBe` False
    it "Returns true when the text given a string that contains \"text/html\"" htmlProp
    it "Returns false when given a string that doesn't contain \"text/html\"" htmlPropFalse
  EventSpec.spec
