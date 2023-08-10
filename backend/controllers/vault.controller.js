const { validationResult } = require('express-validator');
const db = require('../models');
const User = db.User;
const Vault = db.Vault;
const Application = db.Application;

exports.getdata = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    Vault.findAll({
        where: { UserId: req.UserId },
        attributes: ['id', 'saved_password', 'vault_name'],
        include: [{
            model: Application,
            attributes: ['app_id', 'name', 'category', 'imageurl']
        }]
    }).then(vaults => {
        var ret = {};
        if (req.body.option == "category") {
            vaults.forEach(element => {
                var categ = element.Application.category.toString();
                if (Object.keys(ret).includes(categ)) {
                    ret[categ].push(element);
                } else {
                    ret[categ] = [element];
                }
            });
            var rets = [];
            Object.keys(ret).forEach(element => {
                rets.push({ "category": element, "data": ret[element] });
            });
            res.status(200).send({ data: rets });
        } else {
            res.status(200).send({ data: vaults });
        }
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
}


exports.getfromid = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    Vault.findOne({
        where: { UserId: req.UserId, id: req.body.VaultId },
        attributes: ['id', 'saved_password', "vault_name"],
        include: [{
            model: Application,
            attributes: ['app_id', 'name', 'imageurl', 'category']
        }]
    }).then(vaults => {
        res.status(200).send({ data: vaults });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
}


exports.create = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    User.findOne({
        where: { id: req.UserId },
    }).then(user => {
        if (!user) {
            return res.status(400).json({ message: "User not found" });
        }
        Application.findOne({
            where: { id: req.body.ApplicationId },
        }).then(app => {
            if (!app) {
                return res.status(400).json({ message: "Application not found" });
            }
            Vault.create({
                UserId: req.UserId,
                ApplicationId: req.body.ApplicationId,
                saved_password: req.body.saved_password,
                vault_name: req.body.vault_name
            }).then(x => {
                return res.status(200).send({ message: "Created new password sucessfully!" });
            }).catch(err => {
                console.log(err);
                return res.status(500).send({ message: err.message });
            });
        }).catch(err => {
            console.log(err);
            return res.status(500).send({ message: err.message });
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).send({ message: err.message });
    });
}

exports.destroy = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    Vault.findOne({
        where: { id: req.body.VaultId },
    }).then(app => {
        if (app.UserId != req.UserId) {
            return res.status(400).json({ message: "Insufficient privileges" });
        }
        Vault.destroy({ where: { id: req.body.VaultId } }).then(data => {
            res.status(200).send({ message: "Destroy record password sucessfully!" });
        }).catch(err => {
            console.log(err);
            res.status(500).send({ message: err.message });
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).send({ message: err.message });
    });
}

exports.edit = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    Vault.findOne({
        where: { id: req.body.VaultId },
    }).then(app => {
        if (app.UserId != req.UserId) {
            return res.status(400).json({ message: "Insufficient privileges" });
        }
        Vault.update({
            saved_password: req.body.saved_password
        }, { where: { id: req.body.VaultId } }).then(x => {
            res.status(200).send({ message: "Change password successfully!" });
        }).catch(err => {
            console.log(err);
            res.status(500).send({ message: err.message });
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).send({ message: err.message });
    });
}