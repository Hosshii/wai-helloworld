{-# LANGUAGE OverloadedStrings #-}

module Handler (index, hello, notFound, Handler, t1) where

import qualified Network.HTTP.Types as HType
import qualified Network.Wai as Wai

type Handler = Wai.Request -> Wai.Response

notFound :: Handler
notFound _ = Wai.responseLBS HType.status404 [] "Not Found"

index :: Handler
index _ = Wai.responseFile HType.status200 [("Content-Type", "text/html")] "index.html" Nothing

hello :: Handler
hello _ =
  Wai.responseLBS
    HType.status200
    [("Content-Type", "text/plain")]
    "Hello, Web!"

t1 :: Handler
t1 _ = Wai.responseLBS HType.status200 [("Content-Type", "text/plain")] "Hello, t1!"

-- postMessage :: Handler
-- postMessage req =