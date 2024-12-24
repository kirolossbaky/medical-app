import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/export_service.dart';
import 'dart:io';
import 'package:share_plus/share_plus';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  final ExportService _exportService = ExportService();
  bool _notificationsEnabled = true;
  String _reminderTime = '09:00';
  int _reminderInterval = 30;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
      _reminderTime = _prefs.getString('reminder_time') ?? '09:00';
      _reminderInterval = _prefs.getInt('reminder_interval') ?? 30;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('notifications_enabled', _notificationsEnabled);
    await _prefs.setString('reminder_time', _reminderTime);
    await _prefs.setInt('reminder_interval', _reminderInterval);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive medication reminders'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                    _saveSettings();
                  });
                },
              ),
              ListTile(
                title: const Text('Default Reminder Time'),
                subtitle: Text(_reminderTime),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(_reminderTime.split(':')[0]),
                      minute: int.parse(_reminderTime.split(':')[1]),
                    ),
                  );
                  if (time != null) {
                    setState(() {
                      _reminderTime =
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      _saveSettings();
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Reminder Interval'),
                subtitle: Text('$_reminderInterval minutes'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showIntervalDialog(),
              ),
            ],
          ),
          _buildSection(
            'Appearance',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          _buildSection(
            'Data & Storage',
            [
              ListTile(
                title: const Text('Clear App Data'),
                subtitle: const Text('Delete all local data'),
                trailing: const Icon(Icons.delete_forever),
                onTap: () => _showClearDataDialog(),
              ),
              ListTile(
                title: const Text('Export Data'),
                subtitle: const Text('Export your medical data'),
                trailing: const Icon(Icons.upload),
                onTap: () => _showExportDialog(),
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Export as JSON'),
              onTap: () async {
                Navigator.pop(context);
                await _exportData('json');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              onTap: () async {
                Navigator.pop(context);
                await _exportData('csv');
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () async {
                Navigator.pop(context);
                await _exportData('pdf');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(String format) async {
    try {
      String filePath;
      switch (format) {
        case 'json':
          filePath = await _exportService.exportData();
          break;
        case 'csv':
          filePath = await _exportService.generateCSVReport();
          break;
        case 'pdf':
          filePath = await _exportService.exportToPDF();
          break;
        default:
          throw Exception('Unsupported format');
      }

      if (!mounted) return;

      // Share the exported file
      await Share.shareFiles(
        [filePath],
        text: 'Medical App Data Export',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showIntervalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Interval'),
        content: DropdownButton<int>(
          value: _reminderInterval,
          items: [15, 30, 45, 60].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value minutes'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setState(() {
                _reminderInterval = newValue;
                _saveSettings();
              });
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
          'Are you sure you want to clear all app data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _prefs.clear();
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
