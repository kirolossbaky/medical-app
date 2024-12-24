import 'package:flutter/foundation.dart';
import '../models/pharmacy.dart';
import '../models/order.dart';
import '../services/medication_service.dart';
import '../services/order_service.dart';

class PharmacyProvider with ChangeNotifier {
  final MedicationService _medicationService = MedicationService();
  final OrderService _orderService = OrderService();
  List<Pharmacy> _pharmacies = [];
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Pharmacy> get pharmacies => _pharmacies;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchPharmacies(String medicationName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pharmacies = await _medicationService.searchPharmacy(medicationName);
    } catch (e) {
      _error = e.toString();
      _pharmacies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder(Order order) async {
    _isLoading = true;
    notifyListeners();

    try {
      final placedOrder = await _orderService.placeOrder(order);
      _orders.add(placedOrder);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch orders
      await Future.delayed(const Duration(seconds: 1));
      // Dummy data
      _orders = [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> trackOrder(String orderId) async {
    try {
      return await _orderService.trackOrderStatus(orderId);
    } catch (e) {
      _error = e.toString();
      return 'Error tracking order';
    }
  }
}
