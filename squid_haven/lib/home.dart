import 'package:flutter/material.dart';
import 'package:squid_haven/signin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To encode the message to JSON

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username}); // Receive displayName

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _messageController = TextEditingController(); // Controller for the TextField input
  List<Map<String, String>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the page is initialized
  }

  Future<void> _fetchPosts() async {
    const String url = 'http://10.0.2.2:3000/posts/posts'; // Your API endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(
            response.body); // Decode the response into a list
        if (mounted) {
          setState(() {
            posts = data.map((post) =>
            {
              'message': post['message'] as String,
              'username': post['username'] as String,
              'display_name': post['display_name'] as String,
              'postId': post['id'].toString(),
            }).toList();

            // Sort posts by 'created_at' (if it's available in the response)
            posts.sort((a, b) {
              // Compare based on 'created_at', falling back to an empty string if 'created_at' is null
              return (b['created_at'] ?? '').compareTo(a['created_at'] ?? '');
            }); // Sort descending
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch posts')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _createPost(String message) async {
    final String userId = widget
        .username; // You can pass the user ID or username as needed
    const String url = 'http://10.0.2.2:3000/posts/post'; // Your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId, // Pass the user ID
          'message': message, // Pass the message content
        }),
      );

      if (mounted) {
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post created successfully')),
          );
          _fetchPosts(); // Refresh the posts after creating a new post
        } else {
          final errorMessage = json.decode(response.body)['error'] ??
              'Error creating post';
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deletePost(int postId) async {
    final String url = 'http://10.0.2.2:3000/posts/post/$postId'; // Your delete API endpoint

    // Show the confirmation dialog first (synchronously)
    bool confirmDeletion = await _showDeleteConfirmationDialog();

    // If the user confirms, proceed with the delete operation
    if (confirmDeletion) {
      try {
        final response = await http.delete(Uri.parse(url));

        if (mounted) {
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post deleted successfully')),
            );
            _fetchPosts(); // Refresh the posts after deleting one
          } else {
            final errorMessage = json.decode(response.body)['error'] ??
                'Error deleting post';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

// This function shows the confirmation dialog and returns the user's response
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false; // Return false if the user presses outside the dialog
  }


  // Function to show the post dialog
  void _showPostDialog() {
    // Clear the text field before showing the dialog
    _messageController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SizedBox(
            height: 250, // Set a fixed height for the input container
            width: 350,
            child: SingleChildScrollView( // Make the container scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _messageController,
                    maxLines: null,
                    // Allow multiple lines of text
                    maxLength: 300,
                    // Restrict text to 300 characters
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      setState(() { // Update character count
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  //Text('$_charCount/300 characters'), // Display character count
                ],
              ),
            ),
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            // Post button
            TextButton(
              onPressed: () {
                String message = _messageController.text;
                if (message.isNotEmpty) {
                  _createPost(message); // Send API request to create post
                  Navigator.of(context).pop(); // Close the dialog after posting
                }
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      // Set background color to #F1F0E8
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Space between title and username/logout button
          children: [
            const Text(
              'SquidHaven',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              children: [
                Text(
                  'Hi, ${widget.username}!',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _confirmLogout();
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFBFBFB),
        elevation: 0,
      ),
      body: posts.isEmpty
          ? const Center(
        child: Text(
          'There are no posts from all the users. Post now!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchPosts, // Refresh when the user pulls down
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts[index]['display_name'] ?? 'No Display Name',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${posts[index]['username'] ?? 'No Username'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'delete') {
                            final postId = posts[index]['postId'];
                            if (postId != null) {
                              final postIdInt = int.tryParse(postId);
                              if (postIdInt != null) {
                                await _deletePost(postIdInt); // Now triggers the confirmation dialog
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid post ID')),
                                );
                              }
                            }
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(posts[index]['message'] ?? 'No message'),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showPostDialog();
        },
        label: const Row(
          children: [
            Icon(Icons.create),
            SizedBox(width: 8),
            Text('Post'),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}