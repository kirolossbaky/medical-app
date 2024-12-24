import 'package:flutter/material.dart';
import 'medication_screen.dart';
import 'schedule_screen.dart';
import 'pharmacy_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildFeatureCard(
            context,
            'My Medications',
            Icons.medication,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MedicationScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Schedule',
            Icons.calendar_today,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Order Medicine',
            Icons.local_pharmacy,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PharmacyScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Prescriptions',
            Icons.description,
            () {
              // TODO: Navigate to prescriptions screen
            },
          ),
          _buildFeatureCard(
            context,
            'Drug Info',
            Icons.info,
            () {
              // TODO: Navigate to drug info screen
            },
          ),
          _buildFeatureCard(
            context,
            'Interactions',
            Icons.compare_arrows,
            () {
              // TODO: Navigate to interactions screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
