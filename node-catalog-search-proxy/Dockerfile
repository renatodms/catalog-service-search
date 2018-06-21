FROM node

RUN apt-get update && apt-get install -y \
  git

#install and run service
COPY ./ ./
RUN npm install
ENTRYPOINT [ "nodejs", "server.js"]