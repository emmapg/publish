{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CompareFragments where

import Core.Text
import qualified Data.Text.IO as T
import Test.Hspec hiding (context)

import FormatDocument (markdownToPandoc)
import PandocToMarkdown (pandocToMarkdown)

fragments :: [(String,FilePath)]
fragments =
    [ ("headings",      "tests/fragments/Headings.markdown")
    , ("paragraphs",    "tests/fragments/Paragraphs.markdown")
    , ("code blocks",   "tests/fragments/CodeBlocks.markdown")
    , ("LaTeX blocks",  "tests/fragments/LatexBlocks.markdown")
    , ("poem passage",  "tests/fragments/Poetry.markdown")
    ]

checkByComparingFragments :: Spec
checkByComparingFragments =
    describe "Compare fragments" $ do
        sequence_ (map compareFragment fragments)

compareFragment :: (String,FilePath) -> SpecWith ()
compareFragment (label,file) =
    it ("Formats " ++ label ++ " correctly") $ do
        original <- T.readFile file
        doc <- markdownToPandoc original
        let text = pandocToMarkdown doc
        fromRope text `shouldBe` original
