const db = require('../config/database');

const UserModel = {
  createUser: (displayName, email, username, password, callback) => {
    const query = `INSERT INTO users (display_name, email, username, password) VALUES (?, ?, ?, ?)`;
    db.run(query, [displayName, email, username, password], callback);
  },
  getUserByUsername: (username, callback) => {
    const query = `SELECT * FROM users WHERE username = ?`;
    db.get(query, [username], callback);
  }
};

module.exports = UserModel;