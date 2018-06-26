const express = require('express'),
    app = express(),
    http = require('http').createServer(app);

app.get('/series', (req, res) => {
    res.send([{
        serieId: 0,
        serieTitle: 'Serie 1',
        serieAbout: 'Descrição da serie 1'
    },{
        serieId: 1,
        serieTitle: 'Serie 2',
        serieAbout: 'Descrição da serie 2'
    }]);
});

app.get('/seasons', (req, res) => {
    res.send([{
        seasonId: 0,
        seasonTitle: 'Temporada 1 da serie 1'
    },{
        seasonId: 1,
        seasonTitle: 'Temporada 2 da serie 1'
    },{
        seasonId: 2,
        seasonTitle: 'Temporada 1 da serie 2'
    },{
        seasonId: 3,
        seasonTitle: 'Temporada 2 da serie 2'
    }]);
});

http.listen(8080, () => {
    console.log('on 8080');
});