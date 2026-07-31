import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';

class ApiService {
  final String baseUrl;
  String? authToken;

  ApiService({this.baseUrl = AppConfig.baseUrl});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // Auth: Send OTP
  Future<bool> sendOtp(String phone) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/send-otp'),
        headers: _headers,
        body: jsonEncode({'phone': phone}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Auth: Verify OTP
  Future<Map<String, dynamic>?> verifyOtp(String phone, String otp) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/verify-otp'),
        headers: _headers,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        authToken = data['accessToken'];
        return data;
      }
    } catch (_) {}
    return null;
  }

  // Fetch Dhabas from Backend API
  Future<List<dynamic>?> fetchDhabas() async {
    try {
      final res = await http.get(
        Uri.parse(AppConfig.dhabas),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as List<dynamic>;
      }
    } catch (_) {}
    return null;
  }

  // Fetch Mechanics from Backend API
  Future<List<dynamic>?> fetchMechanics() async {
    try {
      final res = await http.get(
        Uri.parse(AppConfig.mechanics),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as List<dynamic>;
      }
    } catch (_) {}
    return null;
  }

  // Post Food Order to Backend API
  Future<bool> createOrder(Map<String, dynamic> orderPayload) async {
    try {
      final res = await http.post(
        Uri.parse(AppConfig.orders),
        headers: _headers,
        body: jsonEncode(orderPayload),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Trigger Panic SOS to Backend API
  Future<bool> sendSOSAlert(Map<String, dynamic> sosPayload) async {
    try {
      final res = await http.post(
        Uri.parse(AppConfig.sos),
        headers: _headers,
        body: jsonEncode(sosPayload),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
