module.exports = (sequelize, DataTypes) => {
    const User = sequelize.define('User', {
        username: {
            type: DataTypes.STRING,
            allowNull: false
        },
        password: {
            type: DataTypes.STRING,
            allowNull: false
        },
        role_rank: {
            type: DataTypes.INTEGER,
            allowNull: false,
            defaultValue: 0,
        },
        // email: {
        //     type: DataTypes.STRING,
        //     allowNull: false
        // },
        // phoneNumber: {
        //     type: DataTypes.STRING,
        //     allowNull: false
        // }
    });

    return User;
};