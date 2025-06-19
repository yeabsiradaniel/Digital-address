import 'package:flutter/cupertino.dart';
import 'package:digital_addressing_app/data/saved_properties.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // Check if this property is already saved when the screen loads.
    _isSaved = SavedProperties.propertyIds.contains(widget.propertyId);
  }

  void _toggleSave() {
    setState(() {
      if (_isSaved) {
        SavedProperties.propertyIds.remove(widget.propertyId);
      } else {
        SavedProperties.propertyIds.add(widget.propertyId);
      }
      _isSaved = !_isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.propertyId),
        // The trailing heart icon is now a functional button.
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _toggleSave,
          child: Icon(
            _isSaved ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            color: _isSaved ? CupertinoColors.systemRed : CupertinoTheme.of(context).primaryColor,
          ),
        ),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 250,
            child: PageView(
              children: [
                Image.network('https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=500', fit: BoxFit.cover),
                Image.network('https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=500', fit: BoxFit.cover),
              ],
            ),
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('DETAILS'),
            children: <Widget>[
              _buildDetailTile(context, leading: CupertinoIcons.bed_double, title: 'Bedrooms', value: '3'),
              _buildDetailTile(context, leading: CupertinoIcons.drop, title: 'Bathrooms', value: '2'),
              const CupertinoListTile(
                leading: Icon(CupertinoIcons.sparkles),
                title: Text('Amenities'),
                subtitle: Text('Private Pool, Air Conditioning, High-Speed Wi-Fi, Garage Parking'),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('DESCRIPTION'),
            children: const [
              CupertinoListTile(
                title: Text(
                  'A beautifully designed home with modern interior and plenty of space for comfortable furnishings.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, {required IconData leading, required String title, required String value}) {
    return CupertinoListTile(
      leading: Icon(leading),
      title: Text(title),
      additionalInfo: Text(value, style: const TextStyle(color: CupertinoColors.secondaryLabel)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    );
  }
}