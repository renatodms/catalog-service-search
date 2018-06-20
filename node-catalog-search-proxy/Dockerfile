FROM node

RUN apt-get update && apt-get install -y \
  git

#install and run service
RUN git clone https://github.com/ahlp/catalog-service-search/
RUN nodejs ./catalog-service-search/node-catalog-search-proxy/server.js