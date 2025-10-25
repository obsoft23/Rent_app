import 'package:flutter/material.dart';

class EditAgentProfilePage extends StatefulWidget {
  const EditAgentProfilePage({Key? key}) : super(key: key);

  @override
  _EditAgentProfilePageState createState() => _EditAgentProfilePageState();
}

class _EditAgentProfilePageState extends State<EditAgentProfilePage> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with dummy data or fetch from API
    nameController.text = "John Doe";
    emailController.text = "johndoe@example.com";
    phoneController.text = "+1234567890";
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void saveEdits() {
    // Save the updated details (e.g., send to API)
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Agent Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (!isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: toggleEditing,
                  child: const Text('Edit Profile'),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: isEditing
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: saveEdits,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
