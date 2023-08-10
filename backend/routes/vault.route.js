const express = require('express');
const app = express();
const controller = require('../controllers/vault.controller');
const { body } = require('express-validator');
const { verifyToken } = require("../middleware");

const vaultHashValidator = [
    body('saved_password')
    .notEmpty()
    .withMessage('Password is required')
    .isLength({ min: 64, max: 255 })
    .withMessage('Password must be at 64-255 characters long')
];

app.post('/create', [
    verifyToken,
    vaultHashValidator,
    body('ApplicationId').isNumeric(),
    body('vault_name').isLength({ min: 1 }),
], controller.create);

app.post('/destroy', [
    verifyToken,
    body('VaultId').isNumeric(),
], controller.destroy);

app.post('/edit', [
    verifyToken,
    body('VaultId').isNumeric(),
    vaultHashValidator,
], controller.edit);

app.post('/getdata', [
    verifyToken,
], controller.getdata);

app.post('/getfromid', [
    verifyToken,
    body('VaultId').isNumeric(),
], controller.getfromid);

module.exports = app;