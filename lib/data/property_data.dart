// This class simulates a database of property details.
class PropertyData {
  // A map where the key is the property ID.
  static final Map<String, Map<String, dynamic>> properties = {
    '2134-630-211': {
      'mainType': 'Public',
      'subType': 'Condominium',
      'block': '127/23',
      'bedrooms': 3,
      'bathrooms': 2,
      'imageUrl': 'https://i.ibb.co/L6Yp0rY/ethiopian-condo-1.jpg', // Ethiopian Condo
    },
    '2134-630-458': {
      'mainType': 'Private',
      'subType': 'Apartment',
      'block': null, // No block for this one
      'bedrooms': 2,
      'bathrooms': 1,
      'imageUrl': 'https://i.ibb.co/VvZgNZY/ethiopian-apartment-1.jpg', // Ethiopian Apartment
    },
    '2134-984-371': {
      'mainType': 'Commercial',
      'subType': 'Property',
      'block': null,
      'bedrooms': 0, // No bedrooms for commercial
      'bathrooms': 4,
      'imageUrl': 'https://i.ibb.co/Yc5tM8c/ethiopian-commercial-1.jpg', // Ethiopian Commercial
    },
    // Add more mock properties as needed
  };

  // Helper method to get data for a specific ID.
  static Map<String, dynamic>? getPropertyById(String id) {
    return properties[id];
  }
}