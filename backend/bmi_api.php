<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// เชื่อมต่อฐานข้อมูล
$conn = new mysqli("localhost", "root", "", "bmi_database");

if ($conn->connect_error) {
    http_response_code(500);
    die(json_encode(["error" => "Database connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

// ✅ **จัดการ OPTIONS request (แก้ปัญหา CORS)**
if ($method == "OPTIONS") {
    http_response_code(200);
    exit();
}

// ✅ **ดึงข้อมูลทั้งหมด (Read)**
if ($method == "GET") {
    $result = $conn->query("SELECT * FROM bmi_records");
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode($data);
}

// ✅ **เพิ่มข้อมูลใหม่ (Create)**
elseif ($method == "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data["user_name"], $data["weight"], $data["height"])) {
        $bmi = $data["weight"] / (($data["height"] / 100) ** 2);
        $stmt = $conn->prepare("INSERT INTO bmi_records (user_name, weight, height, bmi) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("sddd", $data["user_name"], $data["weight"], $data["height"], $bmi);

        if ($stmt->execute()) {
            http_response_code(201);
            echo json_encode(["message" => "Record added successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Failed to insert record"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["error" => "Invalid input data"]);
    }
}

// ✅ **อัปเดตข้อมูล (Update)**
elseif ($method == "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data["id"], $data["user_name"], $data["weight"], $data["height"])) {
        $bmi = $data["weight"] / (($data["height"] / 100) ** 2);
        $stmt = $conn->prepare("UPDATE bmi_records SET user_name=?, weight=?, height=?, bmi=? WHERE id=?");
        $stmt->bind_param("sdddi", $data["user_name"], $data["weight"], $data["height"], $bmi, $data["id"]);

        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(["message" => "Record updated successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Failed to update record"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["error" => "Invalid input data"]);
    }
}

// ✅ **ลบข้อมูล (Delete)**
elseif ($method == "DELETE") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data["id"])) {
        $stmt = $conn->prepare("DELETE FROM bmi_records WHERE id=?");
        $stmt->bind_param("i", $data["id"]);

        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(["message" => "Record deleted successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Failed to delete record"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["error" => "Invalid input data"]);
    }
}

// ❌ **ถ้าใช้ Method ที่ไม่รองรับ**
else {
    http_response_code(405);
    echo json_encode(["error" => "Invalid request method"]);
}

$conn->close();
?>
