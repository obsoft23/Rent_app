import 'package:flutter/material.dart';
import 'package:rentapp/theme/theme.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({
    super.key,
    this.onSubmit,
    required String initialLocation,
  });

  /// Called when a location is chosen. Replace with your geocoder/navigation.
  final void Function(String query)? onSubmit;

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  // In-memory recent searches. Swap to SharedPreferences for persistence.
  final List<String> _recents = <String>[
    'formula 1',
  ]; // example from your screenshot

  // Simple local “data source” – replace with your places API results.
  static const List<String> _sampleLocations = <String>[
    'Lagos, Nigeria',
    'London, United Kingdom',
    'Manchester, United Kingdom',
    'Chorley, United Kingdom',
    'Abuja, Nigeria',
    'Toronto, Canada',
    'Vancouver, Canada',
    'New York, USA',
    'San Francisco, USA',
    'Johannesburg, South Africa',
    'Accra, Ghana',
    'Cairo, Egypt',
  ];

  String _query = '';

  @override
  void initState() {
    super.initState();
    // Autofocus like iOS search.
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _focus.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final v = value.trim();
    if (v.isEmpty) return;

    // Update recents (dedupe + move to top, keep max 10).
    setState(() {
      _recents.removeWhere((e) => e.toLowerCase() == v.toLowerCase());
      _recents.insert(0, v);
      if (_recents.length > 10) _recents.removeLast();
    });

    widget.onSubmit?.call(v);
    // Do nothing else here—leave the screen open like iOS Search.
    // If you want to close after submit: Navigator.pop(context, v);
  }

  List<String> _filtered(String input) {
    final q = input.toLowerCase();
    return _sampleLocations
        .where((e) => e.toLowerCase().contains(q))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _query.isEmpty ? const <String>[] : _filtered(_query);

    return Scaffold(
      body: Column(
        children: [
          // Top search row
          SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.arrow_back, size: 24, color: igBlue),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                  const Icon(Icons.search, size: 20, color: igBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _submit,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() => _query = '');
                      _focus.requestFocus();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white54,
                    ),
                    ),
                  ],
                ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text('Cancel', style: TextStyle(color: igBlue)),
              ),
              ],
            ),
          ),

          // Content (recent when empty, suggestions while typing)
          Expanded(
            child: _query.isEmpty
                ? _RecentSection(
                    recents: _recents,
                    onTap: (v) {
                      _controller.text = v;
                      setState(() => _query = v);
                      _submit(v);
                    },
                    onClearAll: () => setState(_recents.clear),
                  )
                : _SuggestionList(
                    items: suggestions,
                    query: _query,
                    onTap: (v) => _submit(v),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection({
    required this.recents,
    required this.onTap,
    required this.onClearAll,
  });

  final List<String> recents;
  final ValueChanged<String> onTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row: "Recent searches" + clear button (×)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
          child: Row(
            children: [
              const Text(
                'Recent searches',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Clear all',
                onPressed: recents.isEmpty ? null : onClearAll,
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: recents.isEmpty
              ? const Center(
                  child: Text(
                    'No recent searches',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.separated(
                  itemCount: recents.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white12),
                  itemBuilder: (context, i) {
                    final text = recents[i];
                    return ListTile(
                      title: Text(text),
                      // little north-east arrow like your screenshot
                      trailing: const Icon(Icons.north_east, size: 18),
                      onTap: () => onTap(text),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.items,
    required this.query,
    required this.onTap,
  });

  final List<String> items;
  final String query;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No results', style: TextStyle(color: Colors.white54)),
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Colors.white12),
      itemBuilder: (context, i) {
        final text = items[i];

        // Bold the matched part for a nice touch.
        final lower = text.toLowerCase();
        final idx = lower.indexOf(query.toLowerCase());
        final before = idx == -1 ? text : text.substring(0, idx);
        final match = idx == -1 ? '' : text.substring(idx, idx + query.length);
        final after = idx == -1 ? '' : text.substring(idx + query.length);

        return ListTile(
          title: idx == -1
              ? Text(text)
              : RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: before),
                      TextSpan(
                        text: match,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: after),
                    ],
                  ),
                ),
          leading: const Icon(Icons.place_outlined),
          onTap: () => onTap(text),
        );
      },
    );
  }
}

/**
Hooking up a real places API (optional)
Replace _sampleLocations and _filtered with your API calls (e.g., Google Places, Mapbox, OpenStreetMap).
When an item is selected, _submit() is where you can navigate or fetch coordinates.
To persist recents across launches, store _recents with shared_preferences (write on change, read in initState).

 */
