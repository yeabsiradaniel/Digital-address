import 'package:flutter/material.dart';

class SearchPreferencesScreen extends StatefulWidget {
  const SearchPreferencesScreen({super.key});

  @override
  State<SearchPreferencesScreen> createState() => _SearchPreferencesScreenState();
}

class _SearchPreferencesScreenState extends State<SearchPreferencesScreen> {
  // State variables remain the same
  String _propertyType = 'COMMERCIAL';
  String _subType = 'CONDOMINIUM';
  double _floorValue = 3;
  double _sizeValue = 180;
  String _bedrooms = '2 Beds';
  Set<String> _utilities = {'Heat', 'Water'};
  String _taxStatus = 'Payed';
  bool _onlyShowAvailable = true;
  bool _hideRemote = false;

  void _applyFilterAndReturn() {
    Navigator.of(context).pop(_propertyType.toLowerCase());
  }

  void _savePreferences() {
    // TODO: Implement the logic to save the user's preferences.
    print('Save button pressed. Implement save logic here.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences Saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Preferences'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        children: [
          _buildSectionHeader('PROPERTY TYPE'),
          _buildRectangularToggleButtons(
            options: const ['PUBLIC', 'PRIVATE', 'COMMERCIAL'],
            selected: _propertyType,
            onSelected: (value) => setState(() => _propertyType = value),
          ),
          const SizedBox(height: 10),
          _buildPillChoiceChips(
            options: const ['INDUSTRIAL', 'APARTMENT', 'CONDOMINIUM'],
            selected: _subType,
            onSelected: (value) => setState(() => _subType = value),
          ),
          _buildSectionHeader('FLOOR'),
          _buildSlider(
            value: _floorValue, min: 0, max: 9, divisions: 9,
            label: _floorValue.round().toString(),
            onChanged: (value) => setState(() => _floorValue = value),
          ),
          _buildSectionHeader('SIZE'),
          _buildSlider(
            value: _sizeValue, min: 0, max: 400, divisions: 20,
            label: '${_sizeValue.round()} M²',
            onChanged: (value) => setState(() => _sizeValue = value),
          ),
          _buildSectionHeader('BEDROOM'),
          _buildRectangularToggleButtons(
            options: const ['Studio', '1 Bed', '2 Beds', '3 Beds', '4+'],
            selected: _bedrooms,
            onSelected: (value) => setState(() => _bedrooms = value),
          ),
          _buildSectionHeader('UTILITIES'),
          _buildPillChoiceChips(
            options: const ['Heat', 'Electricity', 'Water', 'Internet'],
            selectedSet: _utilities,
            onSelected: (value) {
              setState(() {
                _utilities.contains(value) ? _utilities.remove(value) : _utilities.add(value);
              });
            },
          ),
          _buildSectionHeader('TAX'),
          _buildRectangularToggleButtons(
            options: const ['Payed', 'Pending'],
            selected: _taxStatus,
            onSelected: (value) => setState(() => _taxStatus = value),
          ),
          const SizedBox(height: 24),
          _buildSwitchTile('Only show properties available in the City', _onlyShowAvailable, (value) => setState(() => _onlyShowAvailable = value)),
          _buildSwitchTile('Hide properties without DA', _hideRemote, (value) => setState(() => _hideRemote = value)),
          const SizedBox(height: 24),
        ],
      ),
      persistentFooterButtons: [
        _buildActionButtons(),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  // **THIS WIDGET IS NOW CORRECT**
  Widget _buildRectangularToggleButtons({required List<String> options, required String selected, required ValueChanged<String> onSelected}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // A Row in a SingleChildScrollView will allow its children to be their natural width.
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton(
              onPressed: () => onSelected(option),
              style: OutlinedButton.styleFrom(
                foregroundColor: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                // The incorrect `textStyle` property has been removed from here.
              ),
              // **THE FIX IS HERE**: `softWrap: false` is added to the Text widget.
              child: Text(
                option,
                softWrap: false, // This prevents the text from wrapping to a new line.
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPillChoiceChips({List<String> options = const [], String? selected, Set<String>? selectedSet, required ValueChanged<String> onSelected}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = selected != null ? option == selected : selectedSet!.contains(option);
        return ElevatedButton(
          onPressed: () => onSelected(option),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondaryContainer,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(option),
        );
      }).toList(),
    );
  }

  Widget _buildSlider({required double value, required double min, required double max, required int divisions, required String label, required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        Slider(
          value: value, min: min, max: max, divisions: divisions,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: _applyFilterAndReturn, child: const Text('Search'))),
          const SizedBox(width: 16),
          Expanded(child: ElevatedButton(onPressed: _savePreferences, child: const Text('Save'))),
        ],
      ),
    );
  }
}