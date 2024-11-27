const db = require('../config/database');

const PostModel = {
  createPost: (userId, message, callback) => {
    const query = `INSERT INTO posts (user_id, message) VALUES (?, ?)`;
    db.run(query, [userId, message], callback);
  },
  getPosts: (callback) => {
    const query = `
      SELECT users.display_name, users.username, posts.message, posts.id
      FROM posts
      JOIN users ON posts.user_id = users.username
      ORDER BY posts.created_at DESC`;
    db.all(query, [], callback);
  },
  deletePost: (postId, callback) => {
    const query = `DELETE FROM posts WHERE id = ?`;
    db.run(query, [postId], callback); 
  }  
};

module.exports = PostModel;