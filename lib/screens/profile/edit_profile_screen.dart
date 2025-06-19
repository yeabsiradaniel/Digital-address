import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'Full Name', initialValue: 'Bethlehem Adane'),
            _buildTextField(label: 'Email Address', initialValue: 'beti21@gmail.com'),
            _buildTextField(label: 'Phone Number', initialValue: '0984656745'),
            _buildTextField(label: 'Digital Home Address', initialValue: '1234-233-452'),
            _buildTextField(label: 'Address', initialValue: 'Xyz...'),
            const SizedBox(height: 20),
            _buildProfilePictureField(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Apply', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(initialValue: initialValue),
        ],
      ),
    );
  }

  Widget _buildProfilePictureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Picture', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () { /* TODO: Implement image picker */ },
            ),
          ),
        ),
      ],
    );
  }
}