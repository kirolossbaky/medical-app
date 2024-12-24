import 'package:flutter/material.dart';
import '../models/pharmacy.dart';
import '../services/medication_service.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MedicationService _medicationService = MedicationService();
  List<Pharmacy> _pharmacies = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Pharmacy'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by medication name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _pharmacies.clear();
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _searchPharmacies(value);
              },
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: _pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = _pharmacies[index];
                  return _buildPharmacyCard(pharmacy);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_pharmacy, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStockIndicator(pharmacy),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pharmacy.address,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Order'),
                  onPressed: () {
                    _showOrderDialog(context, pharmacy);
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                  onPressed: () {
                    // TODO: Implement directions
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockIndicator(Pharmacy pharmacy) {
    final stock = pharmacy.checkStock(_searchController.text);
    Color color;
    String text;

    if (stock > 10) {
      color = Colors.green;
      text = 'In Stock';
    } else if (stock > 0) {
      color = Colors.orange;
      text = 'Low Stock';
    } else {
      color = Colors.red;
      text = 'Out of Stock';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _searchPharmacies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final pharmacies = await _medicationService.searchPharmacy(query);
      setState(() {
        _pharmacies = pharmacies;
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

  void _showOrderDialog(BuildContext context, Pharmacy pharmacy) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Place Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pharmacy: ${pharmacy.name}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement order placement
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
