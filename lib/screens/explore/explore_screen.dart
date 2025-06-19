import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar; // <-- FIX: Import CircleAvatar
import 'package:flutter/services.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:digital_addressing_app/data/saved_properties.dart';
import 'package:digital_addressing_app/screens/details/property_details_screen.dart';
import 'package:digital_addressing_app/screens/filters/search_preferences_screen.dart';
import 'package:digital_addressing_app/screens/routing/routing_screen.dart';

enum MapMode { browsing, searchResult, filterResult }

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  MapMode _mode = MapMode.browsing;
  int _zoomLevel = 0;
  String? _currentId;
  bool _showFloors = false;
  int? _selectedFloor;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateZoom(int change) {
    setState(() { _zoomLevel = (_zoomLevel + change).clamp(0, 2); });
  }

  void _handleSearch(String id) {
    if (id.length == 10 && int.tryParse(id) != null) {
      setState(() {
        _mode = MapMode.searchResult;
        _currentId = id;
        _showFloors = false;
        _selectedFloor = null;
        _searchController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  void _resetToDefaultView() {
    setState(() {
      _mode = MapMode.browsing;
      _currentId = null;
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
        _mode = MapMode.filterResult;
        _currentId = result;
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
    switch (_mode) {
      case MapMode.filterResult: return 'assets/images/map_filter_$_currentId.jpg';
      case MapMode.searchResult:
        if (_selectedFloor != null) return 'assets/images/map_floor_$_selectedFloor.jpg';
        return 'assets/images/map_search_result.jpg';
      case MapMode.browsing:
      default:
        switch (_zoomLevel) {
          case 1: return 'assets/images/map_zoom_1.jpg';
          case 2: return 'assets/images/map_zoom_2.jpg';
          default: return 'assets/images/map_default.jpg';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              _getCurrentMapImagePath(),
              key: ValueKey(_getCurrentMapImagePath()),
              fit: BoxFit.fitHeight,
              height: double.infinity,
              width: double.infinity,
            ),
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
          _buildBrowsingControls(),
          _buildSearchResultControls(),
          _buildContextualBackButton(),
        ],
      ),
    );
  }

  Widget _buildBrowsingControls() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _mode == MapMode.browsing ? 1.0 : 0.0,
      child: Stack(
        children: [
          Positioned(
            bottom: 15, right: 15,
            child: Column(
              children: [
                _buildFloatingButton(icon: CupertinoIcons.add, onPressed: () => _updateZoom(1)),
                const SizedBox(height: 10),
                _buildFloatingButton(icon: CupertinoIcons.minus, onPressed: () => _updateZoom(-1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultControls() {
    if (_mode != MapMode.searchResult) return const SizedBox.shrink();

    final isSaved = SavedProperties.propertyIds.contains(_currentId!);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _mode == MapMode.searchResult ? 1.0 : 0.0,
      child: Stack(
        children: [
          Positioned(
            top: 70, right: 15,
            child: Column(
              children: [
                _buildFloatingButton(icon: CupertinoIcons.info, onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PropertyDetailsScreen(propertyId: _currentId!)))),
                const SizedBox(height: 10),
                _buildFloatingButton(icon: CupertinoIcons.list_bullet, onPressed: () => setState(() => _showFloors = !_showFloors)),
                const SizedBox(height: 10),
                _buildFloatingButton(icon: CupertinoIcons.location_fill, onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => RoutingScreen(destinationId: _currentId!)))),
                const SizedBox(height: 10),
                _buildFloatingButton(
                  icon: isSaved ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  iconColor: isSaved ? CupertinoColors.systemRed : null,
                  onPressed: () => _toggleSave(_currentId!),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _showFloors ? 1.0 : 0.0,
            child: _showFloors ? Positioned(
              top: 120, right: 70,
              child: _buildFrostedContainer(
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
            ) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContextualBackButton() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      bottom: _mode != MapMode.browsing ? 15 : -80,
      left: 15,
      child: CupertinoButton.filled(
        child: const Row(children: [Icon(CupertinoIcons.back), SizedBox(width: 8), Text('Back to Map')]),
        onPressed: _resetToDefaultView,
      ),
    );
  }

  // --- FIX: Method signature updated to accept padding and borderRadius ---
  Widget _buildFrostedContainer({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    BorderRadius? borderRadius,
  }) {
    return BlurryContainer(
      blur: 5,
      color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.7),
      elevation: 0,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      padding: padding,
      child: child,
    );
  }

  Widget _buildFloatingSearch() {
    return _buildFrostedContainer(
      // The call now matches the updated method signature
      padding: EdgeInsets.zero,
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
              decoration: const BoxDecoration(color: Color(0x00000000)),
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(CupertinoIcons.slider_horizontal_3),
            onPressed: _openFilters,
          )
        ],
      ),
    );
  }

  Widget _buildFloatingButton({required IconData icon, VoidCallback? onPressed, Color? iconColor}) {
    final defaultIconColor = CupertinoTheme.of(context).brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
    return _buildFrostedContainer(
      // The call now matches the updated method signature
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(30),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        // The CircleAvatar now works because the import was added at the top.
        child: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0x00000000),
          child: Icon(icon, color: iconColor ?? defaultIconColor),
        ),
      ),
    );
  }
}