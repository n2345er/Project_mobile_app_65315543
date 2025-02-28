import 'package:flutter/material.dart';
import '../services/bmi_service.dart';
import '../models/bmi_record.dart';

class EditScreen extends StatefulWidget {
  final BmiRecord record;
  const EditScreen({super.key, required this.record});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final BmiService _bmiService = BmiService();
  bool _isLoading = false; // สถานะโหลด
  late String _bmiCategory;
  late double _bmi;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.record.userName;
    _weightController.text = widget.record.weight.toString();
    _heightController.text = widget.record.height.toString();
    _bmi = widget.record.bmi;
    _bmiCategory = widget.record.getBmiCategory();
  }

  void _calculateBmi() {
    double? weight = double.tryParse(_weightController.text.trim());
    double? height = double.tryParse(_heightController.text.trim());

    if (weight != null && height != null && height > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      setState(() {
        _bmi = bmi;
        _bmiCategory = BmiRecord(
                id: 0, userName: "", weight: weight, height: height, bmi: bmi)
            .getBmiCategory();
      });
    }
  }

  void _updateBmi() async {
    String name = _nameController.text.trim();
    double? weight = double.tryParse(_weightController.text.trim());
    double? height = double.tryParse(_heightController.text.trim());

    if (name.isEmpty || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ กรุณากรอกข้อมูลให้ครบถ้วน")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print("🚀 กำลังอัปเดตข้อมูล...");
      await _bmiService.updateBmiRecord(widget.record.id, name, weight, height);
      print("✅ อัปเดตข้อมูลสำเร็จ!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ อัปเดตข้อมูลสำเร็จ!")),
      );

      Navigator.pop(context, true); // ส่งค่ากลับไปที่ HomeScreen เพื่อรีเฟรช
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ เกิดข้อผิดพลาด: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 📌 ฟังก์ชันกำหนดสีตามระดับ BMI
  Color _getBmiColor(double bmi) {
    if (bmi >= 30.0) {
      return Colors.red; // อ้วนมาก
    } else if (bmi >= 25.0) {
      return Colors.orange; // อ้วน
    } else if (bmi >= 18.6) {
      return Colors.green; // น้ำหนักปกติ
    } else {
      return Colors.blue; // ผอมเกินไป
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไขข้อมูล BMI")),
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
              onChanged: (value) => _calculateBmi(),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: "ส่วนสูง (cm)"),
              keyboardType: TextInputType.number,
              onChanged: (value) => _calculateBmi(),
            ),
            SizedBox(height: 10),
            Text(
              "ผลทดสอบ: $_bmiCategory",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getBmiColor(_bmi)),
            ),
            Text(
              "BMI: ${_bmi.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getBmiColor(_bmi)),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateBmi,
                    child: Text("อัปเดต"),
                  ),
          ],
        ),
      ),
    );
  }
}
