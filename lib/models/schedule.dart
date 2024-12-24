class Schedule {
  final String scheduleId;
  final String medicationId;
  final List<DateTime> dosageTimes;
  final DateTime startDate;
  final DateTime endDate;
  bool reminderEnabled;

  Schedule({
    required this.scheduleId,
    required this.medicationId,
    required this.dosageTimes,
    required this.startDate,
    required this.endDate,
    this.reminderEnabled = true,
  });

  void setReminder() {
    reminderEnabled = true;
  }

  void modifySchedule({
    List<DateTime>? newDosageTimes,
    DateTime? newStartDate,
    DateTime? newEndDate,
  }) {
    if (newDosageTimes != null) {
      dosageTimes.clear();
      dosageTimes.addAll(newDosageTimes);
    }
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      medicationId: json['medicationId'],
      dosageTimes: (json['dosageTimes'] as List)
          .map((time) => DateTime.parse(time))
          .toList(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reminderEnabled: json['reminderEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'medicationId': medicationId,
      'dosageTimes': dosageTimes.map((time) => time.toIso8601String()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reminderEnabled': reminderEnabled,
    };
  }
}
