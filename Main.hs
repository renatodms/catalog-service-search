{-
TODOs
  atualizar tipo de dado (Film)
  atualizar endpoint do CRUD de filmes
  algoritmo de filtro do /search/:filterString
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

--imports para configuracao do servidor
import Web.Scotty

--imports para usar JSON
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics

--imports para requisicao HTTP
import Control.Monad.IO.Class
import Data.Default.Class
import Network.HTTP.Req

--definicoes de tipos (convertidos para JSON)
data Epsode = Epsode { epsodeTitle :: String, epNumber :: Int } deriving (Show, Generic)
instance ToJSON Epsode
instance FromJSON Epsode

data Serie = Serie { serieId :: Int, serieTitle :: String, reusme :: String, launchDate :: String, coverLink :: String, seasons :: [Epsode], commentsId :: [Int] } deriving (Show, Generic)
instance ToJSON Serie
instance FromJSON Serie

--recuperacao dos dados (CRUD de filmes)
getAllEpsodes :: IO [Epsode]
getAllEpsodes = runReq def $ do
  r <- req GET -- metodo
    (http "localhost" /: "epsodes") --url tipo: (http "host" /: "path1" /: "path2" ...)
    NoReqBody -- precisa dizer o que vai mandar do corpo, mesmo que seja nada
    jsonResponse -- o formato da resposta
    mempty       -- mostrar detalhes na resposta
  liftIO $ return (responseBody r :: [Epsode])

getAllSeries :: IO [Serie]
getAllSeries = runReq def $ do
  r <- req GET
    (http "localhost" /: "series")
    NoReqBody
    jsonResponse
    mempty
  liftIO $ return (responseBody r :: [Serie])

--configuracao de endpoints
main :: IO ()
main = do
  putStrLn "smell like it's working..."
  allEpsodes <- getAllEpsodes
  allSeries <- getAllSeries
  scotty 3000 $ do
    get "/series" $ do
      json allSeries
    
    get "/series/:filterString" $ do
      filterString <- param "filterString"
      json (filterString :: String)

    get "/episodes" $ do
      json allEpsodes
      
    get "/episodes/:filterString" $ do
      filterString <- param "filterString"
      json (filterString :: String)