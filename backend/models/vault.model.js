module.exports = (sequelize, DataTypes) => {
    const Vault = sequelize.define('Vault', {
        saved_password: {
            type: DataTypes.STRING,
            allowNull: false
        },
        vault_name: {
            type: DataTypes.STRING,
            allowNull: false
        }
    });

    return Vault;
};