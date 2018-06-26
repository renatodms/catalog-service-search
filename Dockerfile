FROM haskell

RUN apt-get update && apt-get install -y \
  git

#install and run service
COPY ./ catalog-service-search/
RUN cabal update
RUN cabal install req
RUN cabal install scotty
ENTRYPOINT [ "runghc", "./catalog-service-search/Main.hs" ]