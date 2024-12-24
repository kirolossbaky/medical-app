import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddMedicationDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 10, // Replace with actual medication list length
        itemBuilder: (context, index) {
          return _buildMedicationCard(context);
        },
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        leading: const CircleAvatar(
          child: Icon(Icons.medication),
        ),
        title: const Text('Medication Name'),
        subtitle: const Text('1 pill, twice daily'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Active Ingredients:', 'Ingredient 1, Ingredient 2'),
                const SizedBox(height: 8),
                _buildInfoRow('Dosage:', '1 pill twice daily'),
                const SizedBox(height: 8),
                _buildInfoRow('Side Effects:', 'Drowsiness, Nausea'),
                const SizedBox(height: 8),
                _buildInfoRow('Manufacturer:', 'Pharma Corp'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.alarm),
                      label: const Text('Set Reminder'),
                      onPressed: () {
                        // TODO: Implement reminder functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Medication'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement save functionality
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
