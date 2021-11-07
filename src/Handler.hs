{-# LANGUAGE OverloadedStrings #-}

module Handler (index, hello, notFound, Handler) where

import qualified Network.HTTP.Types as HType
import qualified Network.Wai as Wai

type Handler = Wai.Request -> Wai.Response

index :: Handler
index _ = Wai.responseFile HType.status200 [("Content-Type", "text/html")] "index.html" Nothing

hello :: Handler
hello _ =
  Wai.responseLBS
    HType.status200
    [("Content-Type", "text/plain")]
    "Hello, Web!"

notFound :: Handler
notFound _ = Wai.responseLBS HType.status404 [] "Not Found"