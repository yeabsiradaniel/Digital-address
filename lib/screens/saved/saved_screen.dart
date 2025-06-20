import 'package:flutter/material.dart';
import 'package:digital_addressing_app/screens/details/property_details_screen.dart';

class SavedProperty {
  final String id;
  final String type;
  final String imageUrl;
  SavedProperty({required this.id, required this.type, required this.imageUrl});
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated list to use local asset paths
    final List<SavedProperty> savedProperties = [
      SavedProperty(id: 'ID: 2134-630-211', type: 'Single-Family', imageUrl: 'assets/images/villa.jpg'),
      SavedProperty(id: 'ID: 2134-630-458', type: 'Condominium', imageUrl: 'assets/images/condo1.jpg'),
      SavedProperty(id: 'ID: 2134-630-216', type: 'Apartment', imageUrl: 'assets/images/apart.png'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Places')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: savedProperties.length,
        itemBuilder: (context, index) {
          final property = savedProperties[index];
          return _buildPropertyCard(context, property);
        },
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, SavedProperty property) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PropertyDetailsScreen(propertyId: property.id),
      )),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset( // Changed from Image.network to Image.asset
                property.imageUrl,
                fit: BoxFit.cover, // This will crop the image to fit the container without changing its aspect ratio
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(property.type, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}