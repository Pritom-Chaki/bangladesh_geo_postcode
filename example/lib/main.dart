import 'package:flutter/material.dart';
import 'package:bangladesh_geo_postcode/bangladesh_geo_postcode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationCache.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BD Geo Postcode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const _service = LocationService();

  late final TabController _tabController;

  // ── Browse tab state ────────────────────────────────────────────────
  Language _lang = Language.en;

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedThana;

  List<String> _divisions = [];
  List<String> _districts = [];
  List<String> _thanas = [];
  List<Location> _results = [];

  // ── Search tab state ────────────────────────────────────────────────
  final _searchController = TextEditingController();
  List<Location> _searchResults = [];
  String? _searchMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDivisions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Data loading ────────────────────────────────────────────────────

  void _loadDivisions() {
    setState(() {
      _divisions = _service.getDivisions(_lang);
      _selectedDivision = null;
      _selectedDistrict = null;
      _selectedThana = null;
      _districts = [];
      _thanas = [];
      _results = [];
    });
  }

  void _onDivisionChanged(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _selectedDivision = value;
      _selectedDistrict = null;
      _selectedThana = null;
      _districts = _service.getDistricts(value, _lang);
      _thanas = [];
      _results = _service.getPostcodesByDivision(value, lang: _lang);
    });
  }

  void _onDistrictChanged(String? value) {
    if (value == null || _selectedDivision == null) {
      return;
    }
    setState(() {
      _selectedDistrict = value;
      _selectedThana = null;
      _thanas = _service.getThanas(_selectedDivision!, value, _lang);
      _results = _service.getPostcodesByDistrict(
        _selectedDivision!,
        value,
        lang: _lang,
      );
    });
  }

  void _onThanaChanged(String? value) {
    if (value == null ||
        _selectedDivision == null ||
        _selectedDistrict == null) return;
    setState(() {
      _selectedThana = value;
      _results = _service.getPostcodesByThana(
        _selectedDivision!,
        _selectedDistrict!,
        value,
        lang: _lang,
      );
    });
  }

  void _toggleLanguage() {
    setState(() {
      _lang = _lang == Language.en ? Language.bn : Language.en;
    });
    _loadDivisions();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    final all = LocationCache.instance.searchAllByPostcode(query);
    setState(() {
      _searchResults = all;
      _searchMessage =
          all.isEmpty ? 'No results found for "$query"' : null;
    });
  }

  // ── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BD Geo Postcode'),
        actions: [
          TextButton.icon(
            onPressed: _toggleLanguage,
            icon: const Icon(Icons.language),
            label: Text(_lang == Language.en ? 'BN' : 'EN'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.list)),
            Tab(text: 'Search', icon: Icon(Icons.search)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildSearchTab(),
        ],
      ),
    );
  }

  // ── Browse tab ──────────────────────────────────────────────────────

  Widget _buildBrowseTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildDropdown(
                label: _lang == Language.en ? 'Division' : 'বিভাগ',
                value: _selectedDivision,
                items: _divisions,
                onChanged: _onDivisionChanged,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                label: _lang == Language.en ? 'District' : 'জেলা',
                value: _selectedDistrict,
                items: _districts,
                onChanged: _onDistrictChanged,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                label: _lang == Language.en ? 'Thana' : 'থানা',
                value: _selectedThana,
                items: _thanas,
                onChanged: _onThanaChanged,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                '${_results.length} results',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(child: _buildResultsList(_results)),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      initialValue: value,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  // ── Search tab ──────────────────────────────────────────────────────

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        _lang == Language.en ? 'Postcode' : 'পোস্টকোড',
                    hintText: _lang == Language.en ? '1206' : '১২০৬',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ],
          ),
        ),
        if (_searchMessage != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _searchMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        Expanded(child: _buildResultsList(_searchResults)),
      ],
    );
  }

  // ── Shared result list ──────────────────────────────────────────────

  Widget _buildResultsList(List<Location> locations) {
    if (locations.isEmpty) {
      return const Center(
        child: Text('Select a filter or search a postcode'),
      );
    }
    return ListView.separated(
      itemCount: locations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final loc = locations[i];
        final isEn = _lang == Language.en;
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              isEn ? loc.postcodeEn : loc.postcodeBn,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          title: Text(
            isEn ? loc.subofficeEn : loc.subofficeBn,
          ),
          subtitle: Text(
            isEn
                ? '${loc.thanaEn}, ${loc.districtEn}, ${loc.divisionEn}'
                : '${loc.thanaBn}, ${loc.districtBn}, ${loc.divisionBn}',
          ),
        );
      },
    );
  }
}
