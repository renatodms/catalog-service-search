FROM haskell

RUN apt-get update && apt-get install -y \
  git \
  nodejs

#update cabal and install dependencies
RUN cabal update
RUN cabal install req
RUN cabal install scotty

#install and run service
RUN git clone https://github.com/ahlp/catalog-service-search/
RUN nodejs ./catalog-service-search/node-catalog-search-proxy/server.js
RUN runghc ./catalog-service-search/Main.hs