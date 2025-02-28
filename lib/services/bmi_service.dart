import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bmi_record.dart';

class BmiService {
  final String baseUrl = "http://127.0.0.1/backend/bmi_api.php";
  Future<List<BmiRecord>> getBmiRecords() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => BmiRecord.fromJson(data)).toList();
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("❌ Exception: $e");
      throw Exception("Failed to connect to API");
    }
  }

  // 📌 **2. เพิ่มข้อมูล BMI (Create)**
  Future<void> addBmiRecord(
      String userName, double weight, double height) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": userName,
          "weight": weight,
          "height": height,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ บันทึกข้อมูลสำเร็จ!");
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to add record");
      }
    } catch (e) {
      print("❌ Exception: $e");
      throw Exception("Failed to connect to API");
    }
  }

  // 📌 **3. แก้ไขข้อมูล BMI (Update)**
  Future<void> updateBmiRecord(
      int id, String userName, double weight, double height) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "user_name": userName,
          "weight": weight,
          "height": height,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ อัปเดตข้อมูลสำเร็จ!");
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to update record");
      }
    } catch (e) {
      print("❌ Exception: $e");
      throw Exception("Failed to connect to API");
    }
  }

  // 📌 **4. ลบข้อมูล BMI (Delete)**
  Future<void> deleteBmiRecord(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        print("✅ ลบข้อมูลสำเร็จ!");
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to delete record");
      }
    } catch (e) {
      print("❌ Exception: $e");
      throw Exception("Failed to connect to API");
    }
  }
}
