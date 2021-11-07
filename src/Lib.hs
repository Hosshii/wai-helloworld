{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( runApp,
  )
where

import qualified Data.ByteString as B
import qualified Data.List as List
import qualified Handler
import qualified Network.HTTP.Types as HType
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp

runApp :: IO ()
runApp = do
  putStrLn $ "http://localhost:8080/"
  Warp.run 8080 app

app :: Wai.Application
app req respond = respond $ router req req

router :: Wai.Request -> Handler.Handler
router req = router_ req routerMap

type Path = B.ByteString

router_ :: Wai.Request -> [(Path, [(HType.Method, Handler.Handler)])] -> Handler.Handler
router_ req routes = handler
  where
    handler_ = List.find (\(path, _) -> path == Wai.rawPathInfo req) routes
    handler = case handler_ of
      Just (_, handlers) -> maybe Handler.notFound snd (List.find (\(method, _) -> method == Wai.requestMethod req) handlers)
      Nothing -> Handler.notFound

routerMap :: [(Path, [(HType.Method, Handler.Handler)])]
routerMap =
  [ ("/", [(HType.methodGet, Handler.index)]),
    ("/hello", [(HType.methodGet, Handler.hello)])
  ]