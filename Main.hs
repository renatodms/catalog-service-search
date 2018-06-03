{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty

main = scotty 3000 $
  get "/search" $ do
    json ("message" :: String, "Catalog Search Service in on" :: String)