const express = require('express');
const routes = require('./routes');
const cors = require("cors");
const bodyParser = require("body-parser");

const corsOptions = {
    origin: 'http://localhost',
    'Access-Control-Allow-Origin': 'http://localhost',
    withCredentials: false,
    'access-control-allow-credentials': true,
    credentials: false,
    optionSuccessStatus: 200,
}

const app = express();

const busboy = require('connect-busboy');
app.use(busboy());

app.use(cors()); //corsOptions));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

// app.use(express.json());
app.use('/api', routes);

// db sync
const sync_db = 0;
if (sync_db) {
    const db = require('./models');
    db.User.sync();
    db.Application.sync();
    db.Vault.sync();
}

const port = 3000;
app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});