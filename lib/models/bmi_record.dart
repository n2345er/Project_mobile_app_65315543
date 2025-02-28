class BmiRecord {
  int id;
  String userName;
  double weight;
  double height;
  double bmi;

  BmiRecord({
    required this.id,
    required this.userName,
    required this.weight,
    required this.height,
    required this.bmi,
  });

  // 📌 แปลง JSON เป็น Object
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      userName: json['user_name'] ?? "Unknown",
      weight: json['weight'] is double
          ? json['weight']
          : double.tryParse(json['weight'].toString()) ?? 0.0,
      height: json['height'] is double
          ? json['height']
          : double.tryParse(json['height'].toString()) ?? 0.0,
      bmi: json['bmi'] is double
          ? json['bmi']
          : double.tryParse(json['bmi'].toString()) ?? 0.0,
    );
  }

  // 📌 แปลง Object เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_name": userName,
      "weight": weight,
      "height": height,
      "bmi": bmi,
    };
  }

  // 📌 ฟังก์ชันคำนวณระดับ BMI
  String getBmiCategory() {
    if (bmi >= 30.0) {
      return "อ้วนมาก";
    } else if (bmi >= 25.0) {
      return "อ้วน";
    } else if (bmi >= 18.6) {
      return "น้ำหนักปกติ เหมาะสม";
    } else {
      return "ผอมเกินไป";
    }
  }
}
