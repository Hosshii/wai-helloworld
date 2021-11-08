{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( runApp,
  )
where

import Data.Maybe (fromMaybe)
import qualified Handler
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Router

runApp :: IO ()
runApp = do
  putStrLn $ "http://localhost:8080/"
  Warp.run 8080 app

app :: Wai.Application
app req respond = do
  print $ Wai.pathInfo req
  respond $ fromMaybe Handler.notFound (Router.router Router.routeMap (Wai.pathInfo req) (Wai.requestMethod req)) req
