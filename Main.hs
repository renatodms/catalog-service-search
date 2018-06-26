{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

--imports para configuracao do servidor
import Web.Scotty

--imports para usar JSON
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
import qualified Data.Text.Lazy as L

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

--definicoes de tokens globais
newToken = "tTt61KnKc3CG5udTJhIyr58ywPodvF6P"
allTokens = ["tTt61KnKc3CG5udTJhIyr58ywPodvF6P", "R9YDdU342J28SyPofT0RDOmbpnDeWwpN"]

--configuracao de endpoints
main :: IO ()
main = do
  putStrLn "smell like it's working..."
  allSeries <- getAllSeries
  allSeasons <- getAllSeasons
  scotty 8081 $ do
    get "/search/series/:token" $ do
      token <- (param ("token" :: L.Text) :: ActionM L.Text)
      tryReturn (L.unpack token) allSeries
    
    get "/search/series/:token/:serieId" $ do
      token <- (param ("token" :: L.Text) :: ActionM L.Text)
      serieId <- param "serieId"
      tryReturn (L.unpack token) (findSerieById allSeries serieId)

    get "/search/seasons/:token" $ do
      token <- (param ("token" :: L.Text) :: ActionM L.Text)
      tryReturn (L.unpack token) allSeasons
      
    get "/search/seasons/:token/:seasonId" $ do
      token <- (param ("token" :: L.Text) :: ActionM L.Text)
      seasonId <- param "seasonId"
      tryReturn (L.unpack token) (findSeasonById allSeasons seasonId)

    get "/token" $ do
      json (newToken :: String)

    get "/token/check/:token" $ do
      token <- (param ("token" :: L.Text) :: ActionM L.Text)
      json (checkToken allTokens (L.unpack token))

{-
  search utils
-}

--filtrar serie por id
findSerieById :: [Serie] -> Int -> Serie
findSerieById [] _ = Serie (-1) "Not found" "Try another id..."
findSerieById ((Serie serieId serieTitle serieAbout):xs) n
      | n == serieId = Serie serieId serieTitle serieAbout
      | otherwise = findSerieById xs n

--filtrar temporada por id
findSeasonById :: [Season] -> Int -> Season
findSeasonById [] _ = Season (-1) "Not found"
findSeasonById ((Season seasonId seasonTitle):xs) n
      | n == seasonId = Season seasonId seasonTitle
      | otherwise = findSeasonById xs n

--recuperacao dos dados (CRUD de filmes)
getAllSeries :: IO [Serie]
getAllSeries = runReq def $ do
  r <- req GET
    (http "localhost" /: "series")
    NoReqBody
    jsonResponse
    (port 8080)
  liftIO $ return (responseBody r :: [Serie])

--recuperacao dos dados (CRUD de temporadas)
getAllSeasons :: IO [Season]
getAllSeasons = runReq def $ do
  r <- req GET -- metodo
    (http "localhost" /: "seasons")
    NoReqBody
    jsonResponse
    (port 8080)
  liftIO $ return (responseBody r :: [Season])

{-
  token utils
-}

--trata token nas requisicoes de search
tryReturn :: (ToJSON a) => String -> a -> ActionM ()
tryReturn token a
  | (checkToken allTokens token) = json a
  | otherwise = json ("Token inválido!" :: String)

--verifica se token esta ativado
checkToken :: [String] -> String -> Bool
checkToken [] _ = False
checkToken (x:xs) token
  | x == token = True
  | otherwise = checkToken xs token