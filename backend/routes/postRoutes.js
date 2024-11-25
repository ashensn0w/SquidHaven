const express = require('express');
const PostController = require('../controllers/postController');
const router = express.Router();

router.post('/post', PostController.createPost);
router.get('/posts', PostController.getPosts);
router.delete('/post/:postId', PostController.deletePost);

module.exports = router;