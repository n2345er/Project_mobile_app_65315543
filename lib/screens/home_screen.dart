import 'package:flutter/material.dart';
import '../services/bmi_service.dart';
import '../models/bmi_record.dart';
import 'add_screen.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BmiService _bmiService = BmiService();
  List<BmiRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  void _fetchRecords() async {
    try {
      print("🚀 กำลังโหลดข้อมูล...");
      final records = await _bmiService.getBmiRecords();
      setState(() {
        _records = records;
        _isLoading = false;
      });
      print("✅ โหลดข้อมูลสำเร็จ!");
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteRecord(int id) async {
    try {
      await _bmiService.deleteBmiRecord(id);
      setState(() {
        _records.removeWhere((record) => record.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ ลบข้อมูลสำเร็จ!")),
      );
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ ไม่สามารถลบข้อมูลได้!")),
      );
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
      appBar: AppBar(title: Text("BMI Tracker")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? Center(
                  child:
                      Text("ไม่มีข้อมูล BMI", style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(
                          "${record.userName} - BMI: ${record.bmi.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getBmiColor(
                                record.bmi), // เปลี่ยนสีตามระดับ BMI
                          ),
                        ),
                        subtitle: Text(
                          "น้ำหนัก: ${record.weight} kg | ส่วนสูง: ${record.height} cm\n"
                          "ผลทดสอบ: ${record.getBmiCategory()}",
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                bool? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditScreen(record: record),
                                  ),
                                );
                                if (result == true) {
                                  _fetchRecords();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(record.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScreen()),
          );
          if (result == true) {
            _fetchRecords();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้?"),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("ลบ"),
              onPressed: () {
                Navigator.pop(context);
                _deleteRecord(id);
              },
            ),
          ],
        );
      },
    );
  }
}
