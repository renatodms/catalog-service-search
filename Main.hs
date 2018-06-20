{-
TODOs
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
data Serie = Serie { serieId :: Int, serieTitle :: String, serieAbout :: String, serieLaunch_date :: String{-, serieNumber_of_seasons :: Int-} } deriving (Show, Generic)
instance ToJSON Serie
instance FromJSON Serie

data Episode = Episode { serie :: Serie, seasonTitle :: String } deriving (Show, Generic)
instance ToJSON Episode
instance FromJSON Episode

--recuperacao dos dados (CRUD de filmes)
getAllSeries :: IO [Serie]
getAllSeries = runReq def $ do
  r <- req GET
    (http "localhost" /: "series")
    NoReqBody
    jsonResponse
    mempty
  liftIO $ return (responseBody r :: [Serie])

getAllEpisodes :: IO [Episode]
getAllEpisodes = runReq def $ do
  r <- req GET -- metodo
    (http "localhost" /: "episodes") --url tipo: (http "host" /: "path1" /: "path2" ...)
    NoReqBody -- precisa dizer o que vai mandar do corpo, mesmo que seja nada
    jsonResponse -- o formato da resposta
    mempty       -- mostrar detalhes na resposta
  liftIO $ return (responseBody r :: [Episode])
  
  

--configuracao de endpoints
main :: IO ()
main = do
  putStrLn "smell like it's working..."
  allEpisodes <- getAllEpisodes
  allSeries <- getAllSeries
  scotty 3000 $ do
    get "/search/series" $ do
      json allSeries
    
    get "/search/series/:filterString" $ do
      filterString <- param "filterString"
      json (filterString :: String)

    get "/search/episodes" $ do
      json allEpisodes
      
    get "/search/episodes/:filterString" $ do
      filterString <- param "filterString"
      json (filterString :: String)