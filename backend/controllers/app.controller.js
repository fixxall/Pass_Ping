const { validationResult } = require('express-validator');
const db = require('../models');
const User = db.User;
const Vault = db.Vault;
const Application = db.Application;

exports.getdata = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {n
        return res.status(400).json({ errors: errors.array() });
    }
    Application.findAll().then(apps => {
        res.status(200).send({ data: apps });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
}

exports.create = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    } else if (req.RoleRank == 0) {
        return res.status(404).send({ message: "Insufficient privileges" });
    }
    Application.create({
        app_id: req.body.app_id,
        name: req.body.name
    }).then(x => {
        return res.status(200).send({ message: "Created new application record sucessfully!" });
    }).catch(err => {
        console.log(err);
        return res.status(500).send({ message: err.message });
    });
}

exports.destroy = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    } else if (req.RoleRank == 0) {
        return res.status(404).send({ message: "Insufficient privileges" });
    }
    Application.destroy({ where: { id: req.body.ApplicationId } }).then(data => {
        res.status(200).send({ message: "Destroy record password sucessfully!" });
    }).catch(err => {
        console.log(err);
        res.status(500).send({ message: err.message });
    });

}

exports.edit = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    } else if (req.RoleRank == 0) {
        return res.status(404).send({ message: "Insufficient privileges" });
    }
    Application.update({
        app_id: req.body.app_id,
        name: req.body.name
    }, { where: { id: req.body.ApplicationId } }).then(x => {
        res.status(200).send({ message: "Application Edited successfully!" });
    }).catch(err => {
        console.log(err);
        res.status(500).send({ message: err.message });
    });
}