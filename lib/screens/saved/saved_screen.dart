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
    final List<SavedProperty> savedProperties = [
      SavedProperty(id: 'ID: 2134-630-211', type: 'Single-Family', imageUrl: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=500'),
      SavedProperty(id: 'ID: 2134-630-458', type: 'Condominium', imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=500'),
      SavedProperty(id: 'ID: 2134-630-216', type: 'Apartment', imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=500'),
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
              child: Image.network(
                property.imageUrl,
                fit: BoxFit.cover,
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