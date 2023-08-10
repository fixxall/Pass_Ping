module.exports = (sequelize, DataTypes) => {
    const Application = sequelize.define('Application', {
        name: {
            type: DataTypes.STRING,
            allowNull: false
        },
        app_id: {
            type: DataTypes.STRING,
            allowNull: false
        },
        imageurl: {
            type: DataTypes.TEXT,
            allowNull: true
        },
        category: {
            type: DataTypes.STRING,
            allowNull: false
        }
    });

    return Application;
};