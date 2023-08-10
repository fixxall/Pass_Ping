const jwt = require('jsonwebtoken');

verifyToken = (req, res, next) => {

    secret_key = 'DWAINFoinawoidjwoiqjeroiq8ru3298hf8923h8m998r2mx87ry9n2398cbtrct32cr672tb3c67ter2v76rx26b'

    let token = req.headers.authorization;
    if (!token) {
        return res.status(403).send({
            message: "No token provided!"
        });
    }

    jwt.verify(token, secret_key, (err, decoded) => {
        if (err) {
            return res.status(401).send({
                message: "Unauthorized!"
            });
        }
        req.UserId = decoded.UserId;
        req.RoleRank = decoded.RoleRank;
        next();
    });
};

// Export the middleware function
module.exports = {
    verifyToken: verifyToken
};