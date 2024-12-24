import 'medication.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  ready,
  completed,
  cancelled
}

class Order {
  final String orderId;
  final String userId;
  final String pharmacyId;
  final List<Medication> medicationList;
  OrderStatus status;

  Order({
    required this.orderId,
    required this.userId,
    required this.pharmacyId,
    required this.medicationList,
    this.status = OrderStatus.pending,
  });

  bool confirmOrder() {
    if (status == OrderStatus.pending) {
      status = OrderStatus.confirmed;
      return true;
    }
    return false;
  }

  bool cancelOrder() {
    if (status == OrderStatus.pending || status == OrderStatus.confirmed) {
      status = OrderStatus.cancelled;
      return true;
    }
    return false;
  }

  String trackOrder() {
    return 'Order ${orderId} is currently ${status.toString().split('.').last}';
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      pharmacyId: json['pharmacyId'],
      medicationList: (json['medicationList'] as List)
          .map((med) => Medication.fromJson(med))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'pharmacyId': pharmacyId,
      'medicationList': medicationList.map((med) => med.toJson()).toList(),
      'status': status.toString().split('.').last,
    };
  }
}
