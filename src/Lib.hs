{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( runApp,
  )
where

import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp (run)

runApp :: IO ()
runApp = do
  putStrLn $ "http://localhost:8080/"
  run 8080 app3

index :: Response
index = responseFile status200 [("Content-Type", "text/html")] "index.html" Nothing

app3 :: Application
app3 request respond = respond $ case rawPathInfo request of
  "/" -> index
  "/hello" -> hello
  _ -> notFound

hello :: Response
hello =
  responseLBS
    status200
    [("Content-Type", "text/plain")]
    "Hello, Web!"

notFound :: Response
notFound = responseLBS status404 [] "Not Found"