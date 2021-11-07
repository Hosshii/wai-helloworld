{-# LANGUAGE OverloadedStrings #-}

module Db (dbConnect) where

import Database.MySQL.Base
import qualified System.IO.Streams as Streams

dbConnect :: IO (MySQLConn)
dbConnect = do
  connect
    defaultConnectInfo {ciUser = "root", ciPassword = "password", ciDatabase = "database"}

dropAll :: MySQLConn -> IO ()
dropAll conn = do
  putStrLn "start dropping"
  ok <- execute_ conn "DROP TABLE IF EXISTS Haskell"
  print ok
