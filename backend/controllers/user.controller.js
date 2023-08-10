const { validationResult } = require('express-validator');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../models');
const User = db.User;
const { Op } = require("sequelize");

exports.login = (req, res) => {
    secret_key = 'DWAINFoinawoidjwoiqjeroiq8ru3298hf8923h8m998r2mx87ry9n2398cbtrct32cr672tb3c67ter2v76rx26b'
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    User.findOne({
            where: {
                username: req.body.username
            },
        }).then(user => {
            if (!user) {
                return res.status(401).send({ message: "Username has not registered" });
            }
            var passwordIsValid = bcrypt.compareSync(
                req.body.password,
                user.password
            );
            // var passwordIsValid = true;
            if (passwordIsValid) {
                var token = jwt.sign({ UserId: user.id, RoleRank: user.role_rank }, secret_key, {
                    expiresIn: 86400 // 24 hours
                });
                res.status(200).send({
                    accessToken: token
                });

            } else {
                return res.status(401).send({ message: "Password is not matched" });
            }

        })
        .catch(err => {
            console.log(err);
            res.status(500).send({ message: err.message });
        });
};

exports.refreshToken = (req, res) => {
    secret_key = 'DWAINFoinawoidjwoiqjeroiq8ru3298hf8923h8m998r2mx87ry9n2398cbtrct32cr672tb3c67ter2v76rx26b'

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    let token = req.headers.authorization;
    if (!token) {
        return res.status(403).send({
            message: "No token provided!"
        });
    }

    jwt.verify(token, secret_key, { ignoreExpiration: true }, (err, decoded) => {
        if (err || !decoded.UserId || !decoded.RoleRank) {
            return res.status(403).send({
                message: "Invalid token!"
            });
        }
        User.findOne({
                where: {
                    id: decoded.UserId,
                }
            }).then(user => {
                if (!user) {
                    return res.status(404).send({ message: "User Not found." });
                }
                var token = jwt.sign({ UserId: user.id, RoleRank: user.role_rank }, secret_key, {
                    expiresIn: 86400 // 24 hours
                });

                res.status(200).send({
                    accessToken: token
                });

            })
            .catch(err => {
                console.log(err);
                res.status(500).send({ message: err.message });
            });
    });

};

exports.changePassword = (req, res) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    User.findOne({
        where: {
            id: req.UserId
        }
    }).then(user => {
        if (!user) {
            return res.status(401).send({ message: "User Not found." });
        }
        var passwordIsValid = bcrypt.compareSync(
            req.body.recentPassword,
            user.password
        );

        if (!passwordIsValid) {
            return res.status(401).send({
                accessToken: null,
                message: "Invalid Password!"
            });
        } else {
            User.update({
                password: bcrypt.hashSync(req.body.newPassword, 8)
            }, {
                where: { id: req.UserId }
            }).then(user => {
                console.log(`[auth password change][${new Date()}] ${req.UserId} change password`);
                res.send({ message: "Password changed successfully!" });
            }).catch(err => {
                res.status(500).send({ message: err.message });
            });
        }
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
};
exports.getdata = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    User.findOne({
        where: {
            id: req.UserId
        }
    }).then(users => {
        res.status(200).send({ data: users });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
}
exports.getalldata = async(req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    User.findAll({
        where: {
            [Op.or]: [
                { role_rank: 0 },
                {
                    role_rank: {
                        [Op.gte]: req.RoleRank,
                    }
                }
            ]
        }
    }).then(users => {
        res.status(200).send({ data: users });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
}

exports.resetPassword = (req, res) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    User.findOne({
        where: {
            id: req.body.UserId
        }
    }).then(user => {
        if (!user) {
            return res.status(404).send({ message: "User Not found." });
        } else if (req.RoleRank == 0 || req.RoleRank >= user.role_rank) {
            return res.status(404).send({ message: "Insufficient privileges" });
        }
        User.update({
            password: bcrypt.hashSync("default_password", 8)
        }, {
            where: { id: req.body.UserId }
        }).then(user => {
            console.log(`[auth password reset][${new Date()}] ${req.UserId} reset password of ${req.body.UserId}`);
            res.send({ message: "Password reset successfully!" });
        }).catch(err => {
            res.status(500).send({ message: err.message });
        });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
};

exports.edit = (req, res) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    User.findOne({
        where: {
            id: req.UserId
        }
    }).then(user => {
        if (!user) {
            return res.status(404).send({ message: "User Not found." });
        }
        User.update({
            username: req.body.username,
        }, {
            where: { id: req.UserId }
        }).then(user => {
            res.send({ message: "Edited data successfully!" });
        }).catch(err => {
            res.status(500).send({ message: err.message });
        });
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
};

exports.editRank = (req, res) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).send({ message: "Invalid input", errors: errors.array() })
    }
    User.findOne({
        where: {
            id: req.body.UserId
        }
    }).then(user => {
        if (!user) {
            return res.status(404).send({ message: "User Not found." });
        } else if (req.RoleRank == 0 || req.RoleRank >= user.role_rank) {
            return res.status(404).send({ message: "Insufficient privileges" });
        } else if (req.body.RoleRank < req.RoleRank) {
            return res.status(404).send({ message: "Cannot granted into those privileges" });
        } else {
            User.update({
                role_rank: req.body.RoleRank,
            }, {
                where: { id: req.body.UserId }
            }).then(user => {
                res.send({ message: "Edited Role rank data successfully!" });
            }).catch(err => {
                res.status(500).send({ message: err.message });
            });
        }
    }).catch(err => {
        res.status(500).send({ message: err.message });
    });
};


// exports.resetPasswordServer = (npm) => {
//     User.findOne({
//         where: {
//             npm: npm
//         }
//     }).then(user => {
//         User.update({
//             password: bcrypt.hashSync("5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8" + npm, 8)
//         }, {
//             where: { npm: npm }
//         }).then(user => {
//             console.log(`[auth password reset][${new Date()}] server reser password of ${npm}`);
//         }).catch(err => {
//             console.log(err);
//         });
//     }).catch(err => {
//         console.log(err);
//     });
// };

exports.register = async(req, res) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const { username, password } = req.body;

        // Check if the user already exists in the database
        const existingUser = await User.findOne({ where: { username } });
        if (existingUser) {
            return res.status(409).json({ error: 'Username already exists' });
        }

        // Hash the password using bcrypt
        const hashedPassword = await bcrypt.hash(password, 8);

        // Create a new user record in the database
        await User.create({ username, password: hashedPassword });

        // Return a success message
        return res.json({ message: 'Registration successful' });
    } catch (error) {
        console.error('Registration error:', error);
        return res.status(500).json({ error: 'Registration failed' });
    }
}