import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';

class DrugInfoScreen extends StatefulWidget {
  const DrugInfoScreen({super.key});

  @override
  State<DrugInfoScreen> createState() => _DrugInfoScreenState();
}

class _DrugInfoScreenState extends State<DrugInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _drugInfo;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Drug',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchDrug,
                ),
              ),
              onSubmitted: (_) => _searchDrug(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_drugInfo != null)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildDrugInfoCard(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _drugInfo!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            _buildInfoSection('Active Ingredients', _drugInfo!['activeIngredients']),
            _buildInfoSection('Usage', _drugInfo!['usage']),
            _buildInfoSection('Side Effects', _drugInfo!['sideEffects']),
            _buildInfoSection('Warnings', _drugInfo!['warnings']),
            _buildInfoSection('Storage', _drugInfo!['storage']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Future<void> _searchDrug() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
      final info = await medicationProvider.searchDrugInfo(_searchController.text);
      setState(() {
        _drugInfo = info;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
