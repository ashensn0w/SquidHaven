import 'package:flutter/material.dart';
import 'package:squid_haven/signin.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String displayName;

  const HomePage({super.key, required this.username, required this.displayName}); // Receive displayName

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _messageController = TextEditingController(); // Controller for the TextField input
  List<String> posts = []; // List to store posted messages

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
                    maxLines: null, // Allow multiple lines of text
                    maxLength: 300, // Restrict text to 300 characters
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      setState(() {
// Update character count
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
                  setState(() {
                    posts.add(message); // Add the message to the list of posts
                  });
                }
                Navigator.of(context).pop(); // Close the dialog after posting
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  posts.removeAt(index); // Remove post from the list
                });
                Navigator.of(context).pop(); // Close dialog after deletion
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
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
      backgroundColor: const Color(0xFFF1F0E8), // Set background color to #F1F0E8
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and username/logout button
          children: [
            // Display the app title at the leftmost
            const Text(
              'SquidHaven',
              style: TextStyle(fontSize: 20),
            ),
            // Display "Hi, [username]!" and the logout button at the rightmost
            Row(
              children: [
                Text(
                  'Hi, ${widget.username}!', // Access the username via widget.username
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Show confirmation dialog before logging out
                    _confirmLogout();
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFBFBFB),
        elevation: 0, // Optional: removes shadow from the AppBar
      ),
      body: posts.isEmpty // Check if posts list is empty
          ? const Center( // Show this message when no posts are available
        child: Text(
          'There are no posts from all the users. Post now!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: posts.length, // Display the number of posts
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // Background color for each post container
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Username displayed above the message
                    Text(
                      widget.displayName, // Display the username
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Triple dot menu
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmDelete(index); // Call delete confirmation
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert), // Triple dot icon
                    ),
                  ],
                ),
                // const SizedBox(height: 5),
                Text(
                  "@${widget.username}", // Display the username
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Message content
                Text(
                  posts[index], // Display the actual post message
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show the post dialog when the button is clicked
          _showPostDialog();
        },
        label: const Row(
          children: [
            Icon(Icons.create), // Pen icon
            SizedBox(width: 8), // Space between icon and text
            Text('Post'), // Text beside the icon
          ],
        ),
        backgroundColor: Colors.blue, // Background color of the button
      ),
    );
  }
}