{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( runApp,
  )
where

import Data.Maybe (fromMaybe)
import Database.MySQL.Connection (MySQLConn)
import qualified Db
import qualified Handler
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Router

runApp :: IO ()
runApp = do
  putStrLn $ "http://localhost:8080/"
  conn <- Db.dbConnect
  Warp.run 8080 $ app conn

app :: MySQLConn -> Wai.Application
app conn req respond = do
  print $ Wai.pathInfo req
  case handler conn req of
    Handler.NormalResponse n -> respond n
    Handler.IOResponse io -> io >>= respond
  where
    handler = fromMaybe Handler.notFound $ Router.router Router.routeMap (Wai.pathInfo req) (Wai.requestMethod req)
