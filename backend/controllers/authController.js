const UserModel = require('../models/userModel');
const bcrypt = require('bcrypt');

const AuthController = {
  signUp: (req, res) => {
    const { displayName, email, username, password } = req.body;

    bcrypt.hash(password, 10, (err, hashedPassword) => {
      if (err) return res.status(500).json({ error: 'Error encrypting password' });

      UserModel.createUser(displayName, email, username, hashedPassword, (err) => {
        if (err) return res.status(500).json({ error: 'Error creating user' });
        res.status(201).json({ message: 'User registered successfully' });
      });
    });
  },
  signIn: (req, res) => {
    const { username, password } = req.body;

    UserModel.getUserByUsername(username, (err, user) => {
      if (err || !user) return res.status(404).json({ error: 'User not found' });

      bcrypt.compare(password, user.password, (err, isMatch) => {
        if (err || !isMatch) return res.status(401).json({ error: 'Invalid credentials' });
        res.status(200).json({ message: 'Login successful', user });
      });
    });
  }
};

module.exports = AuthController;