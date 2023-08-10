const express = require('express');
const app = express();
const controller = require('../controllers/user.controller');
const { body } = require('express-validator')
const { verifyToken } = require("../middleware");

const passwordValidator = (bodypass) => [
    body(bodypass)
    .notEmpty()
    .withMessage('Password is required')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/\d/)
    .withMessage('Password must contain at least one digit')
];

app.post('/login', [
    body('username').isLength({ min: 1 }),
    // passwordValidator('password')
], controller.login);

app.post('/register', [
    body('username').isLength({ min: 1 }),
    passwordValidator('password')
], controller.register);

app.post('/changepassword', [
    verifyToken,
    passwordValidator('recentPassword'),
    passwordValidator('newPassword')
], controller.changePassword);

app.get('/getdata', [
    verifyToken
], controller.getdata);

app.post('/resetpassword', [
    verifyToken,
    body('UserId').isNumeric(),
], controller.resetPassword);

app.post('/edit', [
    verifyToken,
    body('username').isLength({ min: 1 })
], controller.edit);

app.post('/editrank', [
    verifyToken,
    body('UserId').isNumeric(),
    body('RoleRank').isNumeric()
], controller.editRank);

module.exports = app;