import 'package:flutter/foundation.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch schedules
      await Future.delayed(const Duration(seconds: 1));
      // Dummy data
      _schedules = [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSchedule(Schedule schedule) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to add schedule
      _schedules.add(schedule);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to update schedule
      final index = _schedules.indexWhere((s) => s.scheduleId == schedule.scheduleId);
      if (index != -1) {
        _schedules[index] = schedule;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Schedule> getSchedulesForDate(DateTime date) {
    return _schedules.where((schedule) {
      return schedule.startDate.isBefore(date) && 
             schedule.endDate.isAfter(date);
    }).toList();
  }
}
