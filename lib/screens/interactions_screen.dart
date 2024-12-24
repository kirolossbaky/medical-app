import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../models/medication.dart';

class InteractionsScreen extends StatefulWidget {
  const InteractionsScreen({super.key});

  @override
  State<InteractionsScreen> createState() => _InteractionsScreenState();
}

class _InteractionsScreenState extends State<InteractionsScreen> {
  final List<Medication> _selectedMedications = [];
  List<String> _interactions = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context);
    final medications = medicationProvider.medications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Interactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Select medications to check for interactions',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: medications.map((medication) {
                        final isSelected = _selectedMedications.contains(medication);
                        return FilterChip(
                          label: Text(medication.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMedications.add(medication);
                              } else {
                                _selectedMedications.remove(medication);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _selectedMedications.length >= 2
                          ? _checkInteractions
                          : null,
                      child: const Text('Check Interactions'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_interactions.isNotEmpty)
              Expanded(
                child: Card(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _interactions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.warning, color: Colors.orange),
                        title: Text(_interactions[index]),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkInteractions() async {
    if (_selectedMedications.length < 2) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
      final interactions = await medicationProvider.checkInteractions(_selectedMedications);
      setState(() {
        _interactions = interactions;
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
}
