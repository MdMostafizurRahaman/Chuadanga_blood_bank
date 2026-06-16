import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Donor>> searchDonors({String? bloodGroup, String? upazila}) async {
    final params = <String, String>{};
    if (bloodGroup != null && bloodGroup.isNotEmpty) params['blood_group'] = bloodGroup;
    if (upazila != null && upazila.isNotEmpty) params['upazila'] = upazila;
    final uri = Uri.parse('$baseUrl/donors').replace(queryParameters: params.isNotEmpty ? params : null);
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Donor.fromJson(e)).toList();
    }
    throw Exception('Failed to load donors');
  }

  static Future<Map<String, dynamic>> login(String phone) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) return data;
    throw Exception(data['detail'] ?? 'Login failed');
  }

  static Future<List<String>> getUpazilas() async {
    final res = await http.get(Uri.parse('$baseUrl/upazilas'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<String>.from(data['upazilas']);
    }
    return ['Chuadanga Sadar', 'Alamdanga', 'Damurhuda', 'Jibannagar'];
  }

  static Future<List<String>> getBloodGroups() async {
    final res = await http.get(Uri.parse('$baseUrl/blood-groups'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<String>.from(data['blood_groups']);
    }
    return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  }
}
