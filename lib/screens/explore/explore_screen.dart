import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter/services.dart';
import 'package:digital_addressing_app/data/saved_properties.dart';
import 'package:digital_addressing_app/screens/details/property_details_screen.dart';
import 'package:digital_addressing_app/screens/filters/search_preferences_screen.dart';
import 'package:digital_addressing_app/screens/routing/routing_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // State variables for the interactive simulation
  int _zoomLevel = 0;
  String? _searchedId;
  String? _activeFilter; // New state for filter results
  bool _showFloors = false;
  int? _selectedFloor;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  void _updateZoom(int change) {
    setState(() {
      _zoomLevel = (_zoomLevel + change).clamp(0, 2);
    });
  }

  void _handleSearch(String id) {
    if (id.length == 10 && int.tryParse(id) != null) {
      setState(() {
        _searchedId = id;
        _activeFilter = null;
        _showFloors = false;
        _selectedFloor = null;
        _searchController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  void _resetToDefaultView() {
    setState(() {
      _searchedId = null;
      _activeFilter = null;
      _showFloors = false;
      _selectedFloor = null;
      _zoomLevel = 0;
    });
  }

  Future<void> _openFilters() async {
    final result = await Navigator.of(context).push<String>(
      CupertinoPageRoute(builder: (context) => const SearchPreferencesScreen()),
    );

    if (result != null) {
      setState(() {
        _activeFilter = result;
        _searchedId = null; // Clear any search when a filter is applied
      });
    }
  }

  void _toggleSave(String propertyId) {
    setState(() {
      if (SavedProperties.propertyIds.contains(propertyId)) {
        SavedProperties.propertyIds.remove(propertyId);
      } else {
        SavedProperties.propertyIds.add(propertyId);
      }
    });
  }

  String _getCurrentMapImagePath() {
    if (_activeFilter != null) {
      return 'assets/images/map_filter_$_activeFilter.jpg';
    }
    if (_searchedId != null) {
      if (_selectedFloor != null) {
        return 'assets/images/map_floor_$_selectedFloor.jpg';
      }
      return 'assets/images/map_search_result.jpg';
    }
    switch (_zoomLevel) {
      case 1: return 'assets/images/map_zoom_1.jpg';
      case 2: return 'assets/images/map_zoom_2.jpg';
      default: return 'assets/images/map_default.jpg';
    }
  }

  // --- BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true, minScale: 0.5, maxScale: 4.0,
            // FIX 1: Use BoxFit.fitHeight to preserve verticality
            child: Image.asset(_getCurrentMapImagePath(), key: ValueKey(_getCurrentMapImagePath()), fit: BoxFit.fitHeight, height: double.infinity, width: double.infinity),
          ),
          _buildFloatingUI(),
        ],
      ),
    );
  }

  Widget _buildFloatingUI() {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(top: 10, left: 15, right: 15, child: _buildFloatingSearch()),
          if (_searchedId != null) _buildSearchResultUI(),
          if (_searchedId == null && _activeFilter == null)
            Positioned(
              bottom: 15,
              right: 15,
              child: Column(
                children: [
                  _buildFloatingButton(icon: CupertinoIcons.add, onPressed: () => _updateZoom(1)),
                  const SizedBox(height: 10),
                  _buildFloatingButton(icon: CupertinoIcons.minus, onPressed: () => _updateZoom(-1)),
                ],
              ),
            ),
          // Show a "Clear Filter/Search" button if either is active
          if (_searchedId != null || _activeFilter != null)
            Positioned(
              bottom: 15, left: 15,
              child: CupertinoButton.filled(
                child: const Row(children: [Icon(CupertinoIcons.back), SizedBox(width: 8), Text('Back to Map')]),
                onPressed: _resetToDefaultView,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingSearch() {
    final barColor = CupertinoTheme.of(context).barBackgroundColor;
    return Container(
      decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: CupertinoColors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _searchController,
              placeholder: 'Search by 10-digit ID...',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              onSubmitted: _handleSearch,
              prefix: const Padding(padding: EdgeInsets.only(left: 8.0), child: Icon(CupertinoIcons.search, color: CupertinoColors.systemGrey)),
              decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(12)),
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(CupertinoIcons.slider_horizontal_3),
            onPressed: _openFilters, // Open the filter screen
          )
        ],
      ),
    );
  }

  Widget _buildSearchResultUI() {
    final isSaved = SavedProperties.propertyIds.contains(_searchedId!);
    return Positioned(
      top: 60, right: 15,
      child: Column(
        children: [
          _buildFloatingButton(icon: CupertinoIcons.info, onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: _searchedId!)))),
          const SizedBox(height: 10),
          _buildFloatingButton(icon: CupertinoIcons.list_bullet, onPressed: () => setState(() => _showFloors = !_showFloors)),
          const SizedBox(height: 10),
          _buildFloatingButton(icon: CupertinoIcons.location_fill, onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => RoutingScreen(destinationId: _searchedId!)))),
          const SizedBox(height: 10),
          // The new "Save" button in the search context
          _buildFloatingButton(
            icon: isSaved ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            iconColor: isSaved ? CupertinoColors.systemRed : null, // Make icon red when saved
            onPressed: () => _toggleSave(_searchedId!),
          ),
          if (_showFloors)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: List.generate(7, (index) {
                    final floor = index + 1;
                    return CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('$floor', style: TextStyle(color: CupertinoTheme.of(context).primaryColor)),
                      onPressed: () => setState(() => _selectedFloor = floor),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({required IconData icon, required VoidCallback onPressed, Color? iconColor}) {
    final barColor = CupertinoTheme.of(context).barBackgroundColor;
    final defaultIconColor = CupertinoTheme.of(context).brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
    return Container(
      decoration: BoxDecoration(color: barColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: CupertinoColors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))]),
      child: CupertinoButton(padding: EdgeInsets.zero, onPressed: onPressed, child: CircleAvatar(radius: 22, backgroundColor: barColor, child: Icon(icon, color: iconColor ?? defaultIconColor))),
    );
  }
}