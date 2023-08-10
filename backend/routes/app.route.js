const express = require('express');
const app = express();
const controller = require('../controllers/app.controller');
const { body } = require('express-validator');
const { verifyToken } = require("../middleware");

app.post('/create', [
    verifyToken,
    body('app_id').isLength({ min: 1 }),
    body('name').isLength({ min: 1 }),
], controller.create);

app.post('/destroy', [
    verifyToken,
    body('ApplicationId').isNumeric(),
], controller.destroy);

app.get('/getdata', [
    verifyToken
], controller.getdata);

app.post('/edit', [
    verifyToken,
    body('ApplicationId').isNumeric(),
    body('app_id').isLength({ min: 1 }),
    body('name').isLength({ min: 1 }),
], controller.edit);


module.exports = app;