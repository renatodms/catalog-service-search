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
    host = 'http://ec2-54-187-46-109.us-west-2.compute.amazonaws.com:31885/';

    request({
        method: 'POST',
        uri: host+'login',
        body: credentials,
        json: true
    }).then(result => {

        request({
            method: 'GET',
            uri: host+'csd/api/'+path,
            headers: {
                token: result
            },
            json: true
        }).then(result => {

            res.status(200).send(result);

        }).catch(err => res.status(500).send(err));

    }).catch(err => res.status(500).send(err));
});

http.listen(80, () => {
    console.log('on');
});