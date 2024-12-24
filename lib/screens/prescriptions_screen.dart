import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final List<Map<String, dynamic>> _prescriptions = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = _prescriptions[index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(prescription['date']),
                        subtitle: Text(prescription['doctor']),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showPrescriptionOptions(index),
                        ),
                      ),
                      if (prescription['image'] != null)
                        Image.file(
                          File(prescription['image']),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPrescription,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNewPrescription() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      _showAddPrescriptionDialog(image.path);
    }
  }

  void _showAddPrescriptionDialog(String imagePath) {
    final dateController = TextEditingController();
    final doctorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Prescription Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    dateController.text = date.toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: doctorController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
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
              if (dateController.text.isNotEmpty &&
                  doctorController.text.isNotEmpty) {
                setState(() {
                  _prescriptions.add({
                    'date': dateController.text,
                    'doctor': doctorController.text,
                    'image': imagePath,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrescriptionOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                // TODO: Implement share functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                setState(() {
                  _prescriptions.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
