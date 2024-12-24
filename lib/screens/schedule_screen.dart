import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, hour) {
                return _buildTimeSlot(hour);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          Text(
            DateFormat('EEEE, MMMM d').format(_selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(int hour) {
    final time = TimeOfDay(hour: hour, minute: 0);
    final medications = _getMedicationsForTime(time);

    if (medications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Text(
          time.format(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: medications.map((med) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.medication, size: 20),
                  const SizedBox(width: 8),
                  Text(med),
                ],
              ),
            );
          }).toList(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () {
            // TODO: Mark medications as taken
          },
        ),
      ),
    );
  }

  List<String> _getMedicationsForTime(TimeOfDay time) {
    // TODO: Implement actual schedule logic
    if (time.hour == 8) {
      return ['Medication A - 1 pill', 'Medication B - 2 pills'];
    }
    if (time.hour == 14) {
      return ['Medication C - 1 pill'];
    }
    if (time.hour == 20) {
      return ['Medication A - 1 pill', 'Medication D - 1 pill'];
    }
    return [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddScheduleDialog(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Medication',
                  border: OutlineInputBorder(),
                ),
                items: ['Medication A', 'Medication B', 'Medication C']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  // TODO: Handle medication selection
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Time'),
                trailing: Text(selectedTime.format(context)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
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
              // TODO: Save schedule
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
