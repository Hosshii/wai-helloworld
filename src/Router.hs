{-# LANGUAGE OverloadedStrings #-}

module Router (router, routeMap) where

import qualified Data.ByteString as B
import qualified Data.List as List
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
      T.Node ("messages", [(HType.methodGet, Handler.getMessage)]) []
    ]

goDown :: RouterTree -> SplittedPath -> Maybe RouterTree
goDown (T.Node _ children) path = List.find (\(T.Node (rawpath_, _) _) -> rawpath_ == path) children

router :: RouterTree -> Path -> Method -> Maybe Handler.Handler
router (T.Node handlers _) [] method =
  snd <$> List.find (\(method_, _) -> method_ == method) (snd handlers)
router tree (x : xs) method =
  goDown tree x >>= \tree' -> router tree' xs method