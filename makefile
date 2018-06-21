buildSearch:
	@docker build -t csd-search .
buildSearchGateway:
	@docker cd node-catalog-search-proxy; build -t csd-search-gateway .
build:
	@make buildSearchGateway
	@make buildSearch
run:
	@docker run -d --name csd-search-gateway csd-search-gateway
	@docker run -d --link csd-search-gateway:csd-search-gateway --name csd-search csd-search