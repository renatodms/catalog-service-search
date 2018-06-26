{-
TODOs
  sessao por token
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
data Serie = Serie { serieId :: Int, serieTitle :: String, serieAbout :: String } deriving (Show, Generic)
instance ToJSON Serie
instance FromJSON Serie

data Season = Season { seasonId :: Int, seasonTitle :: String } deriving (Show, Generic)
instance ToJSON Season
instance FromJSON Season

--recuperacao dos dados (CRUD de filmes)
getAllSeries :: IO [Serie]
getAllSeries = runReq def $ do
  r <- req GET
    (http "localhost" /: "series")
    NoReqBody
    jsonResponse
    (port 8080)
  liftIO $ return (responseBody r :: [Serie])

--recuperacao dos dados (CRUD de episodios)
getAllSeasons :: IO [Season]
getAllSeasons = runReq def $ do
  r <- req GET -- metodo
    (http "localhost" /: "seasons")
    NoReqBody
    jsonResponse
    (port 8080)
  liftIO $ return (responseBody r :: [Season])

--configuracao de endpoints
main :: IO ()
main = do
  putStrLn "smell like it's working..."
  allSeries <- getAllSeries
  allSeasons <- getAllSeasons
  scotty 8081 $ do
    get "/search/series" $ do
      json allSeries
    
    get "/search/series/:serieId" $ do
      serieId <- param "serieId"
      json (findSerieById allSeries serieId)

    get "/search/seasons" $ do
      json allSeasons
      
    get "/search/seasons/:seasonId" $ do
      seasonId <- param "seasonId"
      json (findSeasonById allSeasons seasonId)

--finds by id
findSerieById :: [Serie] -> Int -> Serie
findSerieById [] _ = Serie (-1) "Not found" "Try another id..."
findSerieById ((Serie serieId serieTitle serieAbout):xs) n
      | n == serieId = Serie serieId serieTitle serieAbout
      | otherwise = findSerieById xs n

findSeasonById :: [Season] -> Int -> Season
findSeasonById [] _ = Season (-1) "Not found"
findSeasonById ((Season seasonId seasonTitle):xs) n
      | n == seasonId = Season seasonId seasonTitle
      | otherwise = findSeasonById xs n