# Catalog Service Search
Cache Service of [catalog service](https://github.com/ahlp/catalog-service) in Haskell

# How To Build

## Image 
 - make build
 - make run

## Service
 - cd node node-catalog-search-proxy/ 
 - node server.js
 - cd ../
 - runghc Main.hs 

# Known Problems
 - Cache does not have lifetime
 - Dependecy with 2 servers <s> I really don't know why this service use Haskell </s>

# Dependencies
 - https://www.haskell.org/ghc/
 - https://www.haskell.org/cabal/
 - http://hackage.haskell.org/package/req
 - http://hackage.haskell.org/package/scotty
 - https://nodejs.org/
 - https://www.npmjs.com/package/express
 - https://www.npmjs.com/package/request
 - https://github.com/request/request-promise