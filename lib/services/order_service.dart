import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API URL

  Future<Order> placeOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        body: json.encode(order.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return Order.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to place order');
    } catch (e) {
      throw Exception('Error placing order: $e');
    }
  }

  Future<String> trackOrderStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId/status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'];
      }
      throw Exception('Failed to track order');
    } catch (e) {
      throw Exception('Error tracking order: $e');
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
