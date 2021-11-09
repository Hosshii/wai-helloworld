{-# LANGUAGE OverloadedStrings #-}

module Router (router, routeMap) where

import qualified Data.ByteString as B
import qualified Data.List as List
import qualified Data.Maybe as M
import qualified Data.Text as T
import qualified Data.Tree as T
import qualified Handler
import qualified Network.HTTP.Types as HType

type RawPath = B.ByteString

type SplittedPath = T.Text

type Path = [SplittedPath]

type RouterTree = T.Tree (SplittedPath, [(HType.Method, Handler.Handler)])

type Method = HType.Method

routeMap :: RouterTree
routeMap =
  T.Node
    ("/", [(HType.methodGet, Handler.index)])
    [ T.Node ("hello", [(HType.methodGet, Handler.hello), (HType.methodPost, Handler.t1)]) [],
      T.Node ("world", [(HType.methodGet, Handler.hello)]) [],
      T.Node ("messages", [(HType.methodGet, Handler.getMessage)]) [],
      T.Node
        (":id", [(HType.methodGet, Handler.pathParam)])
        [ T.Node ("test", [(HType.methodGet, Handler.pathParam2)]) [],
          T.Node (":id", [(HType.methodGet, Handler.pathParam)]) []
        ]
    ]

router :: RouterTree -> Path -> Method -> Maybe Handler.Handler
router (T.Node handlers _) [] method =
  snd <$> List.find (\(method_, _) -> method_ == method) (snd handlers)
router tree (x : xs) method = handler
  where
    children = List.filter (\(T.Node (rawpath_, _) _) -> rawpath_ == x || T.head rawpath_ == ':') $ T.subForest tree
    handler =
      List.find
        (\tree' -> M.isJust $ router tree' xs method)
        children
        >>= (\tree' -> router tree' xs method)
