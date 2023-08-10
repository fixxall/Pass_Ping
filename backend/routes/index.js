const express = require('express');
const app = express();
const userRoute = require('./user.route');
const vaultRoute = require('./vault.route');
const appRoute = require('./app.route');

app.use('/auth', userRoute);
app.use('/vault', vaultRoute);
app.use('/app', appRoute);

module.exports = app;