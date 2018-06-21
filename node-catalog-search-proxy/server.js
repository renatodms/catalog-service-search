const express = require('express'),
    app = express(),
    http = require('http').createServer(app),
    request = require('request-promise');

app.get('/:path', (req, res) => {
    const path = req.params.path;

    const credentials = {
        login: "node-catalog-search-proxy",
        password: "gambs666"
    },
    host = 'http://csd-crud/';

    //request({
    //    method: 'POST',
    //    uri: host+'login',
    //    body: credentials,
    //    json: true
    //}).then(result => {

        request({
            method: 'GET',
            uri: host+'api/'+path,
            headers: {
                token: 'uE60yfGo2W9RWvLjqZYAbvz60ZjgZ2reXIMOgUchLGd-JnrZNAKsCWclUCzxzhPmnV0-oujD-NBG9_AR7gYvahzHrZpMe6tPH7YgRtmNVwit03fhvY_dtg==',
                ID: 0
            },
            json: true
        }).then(result => {

            if(path == 'series') res.status(200).send(result.series.map(element => {
                return { serieId: element.id, serieTitle: element.title, serieAbout: element.about, serieLaunch_date: element.launch_date, serieNumber_of_seasons: element.number_of_seasons };
            }));

            if(path == 'episodes') res.status(200).send(result.episodes.map(element => {
                return { serie: { serieId: element.serie.id, serieTitle: element.serie.title, serieAbout: element.serie.about, serieLaunch_date: element.serie.launch_date, serieNumber_of_seasons: element.serie.number_of_seasons }, seasonTitle : element.season.title };
            }));

        }).catch(err => res.status(500).send(err));

    //}).catch(err => res.status(500).send(err));
});

http.listen(80, () => {
    console.log('on');
});