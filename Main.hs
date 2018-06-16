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
data Film = Film { filmId :: Int, name :: String } deriving (Show, Generic)
instance ToJSON Film
instance FromJSON Film

--recuperacao dos dados (CRUD de filmes)
getAll :: IO [Film]
getAll = runReq def $ do
  r <- req GET -- metodo
    (http "localhost" /: "filmList") --url tipo: (http "host" /: "path1" /: "path2" ...)
    NoReqBody -- precisa dizer o que vai mandar do corpo, mesmo que seja nada
    jsonResponse -- o formato da resposta
    mempty       -- mostrar detalhes na resposta
  liftIO $ return (responseBody r :: [Film])

--configuracao de endpoints
main :: IO ()
main = do
  putStrLn "smell like it's working..."
  allFilms <- getAll
  scotty 3000 $ do
    get "/search" $ do
      json allFilms
    
    get "/search/:filterString" $ do
      filterString <- param "filterString"
      json (filterString :: String)