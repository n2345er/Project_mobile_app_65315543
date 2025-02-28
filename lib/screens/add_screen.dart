import 'package:flutter/material.dart';
import '../services/bmi_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final BmiService _bmiService = BmiService();

  bool _isLoading = false; // ตัวแปรสถานะโหลดข้อมูล

  void _addBmi() async {
    String name = _nameController.text.trim();
    double? weight = double.tryParse(_weightController.text.trim());
    double? height = double.tryParse(_heightController.text.trim());

    // ✅ ตรวจสอบว่ากรอกข้อมูลครบหรือไม่
    if (name.isEmpty || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ กรุณากรอกข้อมูลให้ครบถ้วน")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // เริ่มโหลด
    });

    try {
      print("🚀 กำลังส่งข้อมูลไปยัง API...");
      await _bmiService.addBmiRecord(name, weight, height);
      print("✅ บันทึกข้อมูลสำเร็จ!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ บันทึกข้อมูลสำเร็จ!")),
      );

      Navigator.pop(context, true); // ปิดหน้าและรีเฟรชข้อมูล
    } catch (e) {
      print("❌ Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ เกิดข้อผิดพลาด: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // หยุดโหลด
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เพิ่มข้อมูล BMI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "ชื่อ"),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: "น้ำหนัก (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: "ส่วนสูง (cm)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // แสดงตัวโหลด
                : ElevatedButton(
                    onPressed: _addBmi,
                    child: Text("บันทึก"),
                  ),
          ],
        ),
      ),
    );
  }
}
