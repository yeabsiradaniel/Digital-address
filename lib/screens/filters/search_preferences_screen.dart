import 'package:flutter/cupertino.dart';

class SearchPreferencesScreen extends StatefulWidget {
  const SearchPreferencesScreen({super.key});

  @override
  State<SearchPreferencesScreen> createState() => _SearchPreferencesScreenState();
}

class _SearchPreferencesScreenState extends State<SearchPreferencesScreen> {
  // State variables for all filter controls
  int _propertyTypeIndex = 2; // Default to COMMERCIAL
  String _selectedSubType = 'CONDOMINIUM';
  double _floorValue = 3.0;
  double _sizeValue = 180.0;
  int _bedroomIndex = 2; // Default to 2 Beds
  Set<String> _selectedUtilities = {'Heat', 'Water'};
  int _taxIndex = 0; // Default to Payed
  bool _onlyShowAvailable = true;
  bool _hideRemote = false;

  void _applyFilterAndReturn() {
    String filterResult;
    switch (_propertyTypeIndex) {
      case 0:
        filterResult = 'public';
        break;
      case 1:
        filterResult = 'private';
        break;
      case 2:
        filterResult = 'commercial';
        break;
      default:
        return;
    }
    Navigator.of(context).pop(filterResult);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Search Preferences'),
      ),
      // --- THE FULL LISTVIEW IS RESTORED HERE ---
      child: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSection(
            header: 'PROPERTY TYPE',
            child: _buildSegmentedControl(
              groupValue: _propertyTypeIndex,
              onValueChanged: (val) => setState(() => _propertyTypeIndex = val!),
              children: const {0: 'PUBLIC', 1: 'PRIVATE', 2: 'COMMERCIAL'},
            ),
          ),
          _buildSection(
            child: _buildChoiceChips(
              options: ['INDUSTRIAL', 'APARTMENT', 'CONDOMINIUM'],
              selected: _selectedSubType,
              onSelected: (val) => setState(() => _selectedSubType = val),
            ),
          ),
          _buildSection(
            header: 'FLOOR',
            child: _buildSliderTile(
              value: _floorValue,
              min: 0, max: 9, divisions: 9,
              label: _floorValue.round().toString(),
              onChanged: (val) => setState(() => _floorValue = val),
            ),
          ),
          _buildSection(
            header: 'SIZE',
            child: _buildSliderTile(
              value: _sizeValue,
              min: 0, max: 400, divisions: 20,
              label: '${_sizeValue.round()} M²',
              onChanged: (val) => setState(() => _sizeValue = val),
            ),
          ),
          _buildSection(
            header: 'BEDROOM',
            child: _buildSegmentedControl(
              groupValue: _bedroomIndex,
              onValueChanged: (val) => setState(() => _bedroomIndex = val!),
              children: const {0: 'Studio', 1: '1 Bed', 2: '2 Beds', 3: '3 Beds', 4: '4+'},
            ),
          ),
          _buildSection(
            header: 'UTILITIES',
            child: _buildMultiChoiceChips(
              options: ['Heat', 'Electricity', 'Water', 'Internet'],
              selected: _selectedUtilities,
              onSelected: (val) {
                setState(() {
                  _selectedUtilities.contains(val) ? _selectedUtilities.remove(val) : _selectedUtilities.add(val);
                });
              },
            ),
          ),
          _buildSection(
            header: 'TAX',
            child: _buildSegmentedControl(
              groupValue: _taxIndex,
              onValueChanged: (val) => setState(() => _taxIndex = val!),
              children: const {0: 'Payed', 1: 'Pending'},
            ),
          ),
          _buildSection(
            child: Column(
              children: [
                _buildSwitchTile(title: 'Only show properties available in the City', value: _onlyShowAvailable, onChanged: (val) => setState(() => _onlyShowAvailable = val)),
                Container(height: 0.5, color: CupertinoColors.separator),
                _buildSwitchTile(title: 'Hide properties without DA', value: _hideRemote, onChanged: (val) => setState(() => _hideRemote = val)),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // --- All helper methods are included below for completeness ---

  Widget _buildSection({String? header, required Widget child}) {
    return CupertinoListSection.insetGrouped(
      header: header != null ? Text(header) : null,
      children: [child],
    );
  }

  Widget _buildSegmentedControl({required int groupValue, required ValueChanged<int?> onValueChanged, required Map<int, String> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: groupValue,
        onValueChanged: onValueChanged,
        children: children.map((key, value) => MapEntry(key, Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(value)))),
      ),
    );
  }

  Widget _buildChoiceChips({required List<String> options, required String selected, required ValueChanged<String> onSelected}) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
        children: options.map((option) {
          final isSelected = option == selected;
          return CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: isSelected ? CupertinoColors.activeBlue : (isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey5),
            child: Text(option, style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.label, fontSize: 14)),
            onPressed: () => onSelected(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiChoiceChips({required List<String> options, required Set<String> selected, required ValueChanged<String> onSelected}) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
        children: options.map((option) {
          final isSelected = selected.contains(option);
          return CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: isSelected ? CupertinoColors.activeBlue : (isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey5),
            child: Text(option, style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.label, fontSize: 14)),
            onPressed: () => onSelected(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderTile({required double value, required double min, required double max, required int divisions, required String label, required ValueChanged<double> onChanged}) {
    return CupertinoListTile(
      title: Row(children: [const Spacer(), Text(label, style: const TextStyle(color: CupertinoColors.secondaryLabel))]),
      subtitle: CupertinoSlider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return CupertinoListTile(
      title: Text(title),
      trailing: CupertinoSwitch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoButton(
              onPressed: _applyFilterAndReturn,
              child: const Text('Search'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CupertinoButton.filled(
              child: const Text('Save'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}