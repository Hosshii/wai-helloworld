{-# LANGUAGE OverloadedStrings #-}

module Lib where

-- ( runApp,
-- )

import qualified Handler as Handler
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp

-- runApp :: IO ()
-- runApp = do
--   putStrLn $ "http://localhost:8080/"
--   Warp.run 8080 app

-- app :: Wai.Application -> Wai.Request -> Wai.Response
-- app request _ = case Wai.rawPathInfo request of
--   "/" -> Handler.index
--   "/hello" -> Handler.hello
--   _ -> Handler.notFound

-- router :: Wai.Application -> Wai.Request -> Wai.Response
-- router (req respond) = respond $ case Wai.rawPathInfo req of
--   "/" -> Handler.index
--   "/hello" -> Handler.hello
--   _ -> Handler.notFound
-- router (Wai.Application a b) = a

router :: Handler.Handler
router req = handler req
  where
    handler = case Wai.rawPathInfo req of
      "/" -> Handler.index
      _ -> Handler.notFound