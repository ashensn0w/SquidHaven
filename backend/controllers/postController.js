const PostModel = require('../models/postModel');

const PostController = {
  createPost: (req, res) => {
    const { userId, message } = req.body;

    PostModel.createPost(userId, message, (err) => {
      if (err) return res.status(500).json({ error: 'Error creating post' });
      res.status(201).json({ message: 'Post created successfully' });
    });
  },
  getPosts: (req, res) => {
    PostModel.getPosts((err, posts) => {
      if (err) return res.status(500).json({ error: 'Error retrieving posts' });
      res.status(200).json(posts);
    });
  },
  deletePost: (req, res) => {
    const { postId } = req.params;
  
    const postIdInt = parseInt(postId, 10); 
  
    if (isNaN(postIdInt)) {
      return res.status(400).json({ error: 'Invalid postId' });
    }
  
    PostModel.deletePost(postIdInt, (err) => {
      if (err) return res.status(500).json({ error: 'Error deleting post' });
      res.status(200).json({ message: 'Post deleted successfully' });
    });
  }
  
};

module.exports = PostController;