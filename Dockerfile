FROM haskell

RUN apt-get update && apt-get install -y \
  git

#update cabal and install dependencies
RUN cabal update
RUN cabal install req
RUN cabal install scotty

#install and run service
RUN git clone https://github.com/ahlp/catalog-service-search/
RUN runghc ./catalog-service-search/Main.hs