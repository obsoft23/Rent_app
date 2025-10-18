import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/search_page/search_page_widget_component/location_search_widget/location_searchpage.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

// ---------- Amenity Checkbox Helper ----------

class _AmenityCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AmenityCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label),
      ],
    );
  }
}

class _FiltersPageState extends State<FiltersPage> {
  // --- State ---
  final TextEditingController _locationCtrl = TextEditingController(
    text: 'Burnley, Lancashire',
  );

  final List<String> _radiusOptions = const [
    'This area',
    '5 miles',
    '10 miles',
  ];
  String _selectedRadius = '0.5 miles';

  // null == “No min/max”
  int? _priceMin;
  int? _priceMax;
  int? _bedMin;
  int? _bedMax = 1; // matches screenshot (right side shows 1)
  int? _bathMin;
  int? _bathMax;

  // Options
  final List<int> _priceSteps = const [
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000,
    1250,
    1500,
    2000,
  ];
  final List<int> _bedCounts = const [1, 2, 3, 4, 5];
  final List<int> _bathCounts = const [1, 2, 3, 4];

  void _clearAll() {
    setState(() {
      _locationCtrl.text = '';
      _selectedRadius = '0.5 miles';
      _priceMin = null;
      _priceMax = null;
      _bedMin = null;
      _bedMax = null;
      _bathMin = null;
      _bathMax = null;
    });
  }

  void _submit() {
    // Do whatever you need with the values (e.g., pop with result or call API).
    final payload = {
      'location': _locationCtrl.text.trim(),
      'radius': _selectedRadius,
      'priceMin': _priceMin,
      'priceMax': _priceMax,
      'bedMin': _bedMin,
      'bedMax': _bedMax,
      'bathMin': _bathMin,
      'bathMax': _bathMax,
    };
    debugPrint('Filters: $payload');
    // Navigator.of(context).pop(payload);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Search tapped')));
  }

  @override
  Widget build(BuildContext context) {
    final navy = const Color(0xFF0B1240); // close to the screenshot
    final chipBg = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: igBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Filters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _clearAll,
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: igBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submit,
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          //const _SectionTitle('Location'),
          GestureDetector(
            onTap: () {
              Get.to(
                () => LocationSearchPage(initialLocation: _locationCtrl.text),
              )?.then((selectedLocation) {
                if (selectedLocation != null) {
                  setState(() {
                    _locationCtrl.text = selectedLocation;
                  });
                }
              });
            },
            child: TextField(
              controller: _locationCtrl,
              decoration: InputDecoration(
                hintText: 'Search location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              enabled: false, // Disable direct editing
            ),
          ),
          const SizedBox(height: 20),

          const _SectionTitle('Search radius'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _radiusOptions.map((opt) {
              final selected = _selectedRadius == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: selected,
                selectedColor: navy,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : null,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                backgroundColor: chipBg,
                onSelected: (_) => setState(() => _selectedRadius = opt),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: selected ? navy : Colors.transparent),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Price'),
          _RangeRow<int>(
            leftLabel: 'No min',
            rightLabel: 'No max',
            values: _priceSteps,
            valueToString: (v) => '£$v',
            minValue: _priceMin,
            maxValue: _priceMax,
            onChangedMin: (v) => setState(() {
              _priceMin = v;
              if (_priceMax != null && v != null && v > _priceMax!) {
                _priceMax = null;
              }
            }),
            onChangedMax: (v) => setState(() => _priceMax = v),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Bedrooms'),
          _RangeRow<int>(
            leftLabel: 'No min',
            rightLabel: 'No max',
            values: _bedCounts,
            valueToString: (v) => '$v',
            minValue: _bedMin,
            maxValue: _bedMax,
            onChangedMin: (v) => setState(() {
              _bedMin = v;
              if (_bedMax != null && v != null && v > _bedMax!) _bedMax = null;
            }),
            onChangedMax: (v) => setState(() {
              _bedMax = v;
              if (_bedMin != null && v != null && v < _bedMin!) _bedMin = null;
            }),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Bathrooms'),
          _RangeRow<int>(
            leftLabel: 'No min',
            rightLabel: 'No max',
            values: _bathCounts,
            valueToString: (v) => '$v',
            minValue: _bathMin,
            maxValue: _bathMax,
            onChangedMin: (v) => setState(() {
              _bathMin = v;
              if (_bathMax != null && v != null && v > _bathMax!) {
                _bathMax = null;
              }
            }),
            onChangedMax: (v) => setState(() {
              _bathMax = v;
              if (_bathMin != null && v != null && v < _bathMin!) {
                _bathMin = null;
              }
            }),
          ),

          const SizedBox(height: 24),
          /* const _SectionTitle('Length of let'),
          // Add your own control here if/when you need it.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: const Text('Add UI (e.g., Any / Short let / Long let)'),
          ),
          SizedBox(height: 24),*/
          const _SectionTitle('Amenities'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AmenityCheckbox(
                label: 'Parking',
                value: false,
                onChanged: (value) {
                  // Handle Parking checkbox state change
                },
              ),
              _AmenityCheckbox(
                label: 'Central Water',
                value: false,
                onChanged: (value) {
                  // Handle Central Water checkbox state change
                },
              ),

              _AmenityCheckbox(
                label: 'Generator',
                value: false,
                onChanged: (value) {
                  // Handle Generator checkbox state change
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- UI Helpers ----------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _RangeRow<T extends Comparable> extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final List<T> values;
  final String Function(T) valueToString;
  final T? minValue;
  final T? maxValue;
  final ValueChanged<T?> onChangedMin;
  final ValueChanged<T?> onChangedMax;

  const _RangeRow({
    required this.leftLabel,
    required this.rightLabel,
    required this.values,
    required this.valueToString,
    required this.minValue,
    required this.maxValue,
    required this.onChangedMin,
    required this.onChangedMax,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DropdownBox<T>(
            hint: leftLabel,
            value: minValue,
            items: values
                .map(
                  (v) => DropdownMenuItem<T>(
                    value: v,
                    child: Text(valueToString(v)),
                  ),
                )
                .toList(),
            onChanged: onChangedMin,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DropdownBox<T>(
            hint: rightLabel,
            value: maxValue,
            items: values
                .map(
                  (v) => DropdownMenuItem<T>(
                    value: v,
                    child: Text(valueToString(v)),
                  ),
                )
                .toList(),
            onChanged: onChangedMax,
          ),
        ),
      ],
    );
  }
}

class _DropdownBox<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownBox({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(hintText: hint),
      items: [
        DropdownMenuItem<T>(value: null, child: Text(hint)),
        ...items,
      ],
      onChanged: onChanged,
    );
  }
}
