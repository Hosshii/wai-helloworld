{-# LANGUAGE OverloadedStrings #-}

module Handler (index, hello, notFound, Handler, t1, Response (..), getMessage) where

import qualified Codec.Binary.UTF8.String as U8S
import qualified Data.ByteString.Lazy as BL
import Database.MySQL.Base
import qualified Network.HTTP.Types as HType
import qualified Network.Wai as Wai
import qualified System.IO.Streams as Streams

type Handler = MySQLConn -> Wai.Request -> Response

data Response
  = NormalResponse Wai.Response
  | IOResponse (IO Wai.Response)

notFound :: Handler
notFound _ _ = NormalResponse $ Wai.responseLBS HType.status404 [] "Not Found"

index :: Handler
index _ _ = NormalResponse $ Wai.responseFile HType.status200 [("Content-Type", "text/html")] "index.html" Nothing

hello :: Handler
hello _ _ =
  NormalResponse $
    Wai.responseLBS
      HType.status200
      [("Content-Type", "text/plain")]
      "Hello, Web!"

t1 :: Handler
t1 _ _ = NormalResponse $ Wai.responseLBS HType.status200 [("Content-Type", "text/plain")] "Hello, t1!"

getMessage :: Handler
getMessage conn _ = IOResponse $ do
  (_, is) <- query_ conn "SELECT message FROM messages"
  msg <- Streams.toList is
  let byteMsg = BL.pack $ U8S.encode $ show msg
  return $ Wai.responseLBS HType.status200 [("Content-Type", "text/plain")] byteMsg
