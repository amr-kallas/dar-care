// Placeholder for OrderModel
// Will need to create a proper model
class OrderModel {
  final int id;
  final String status;
  final DateTime serviceDate;
  // ... other fields

  OrderModel({required this.id, required this.status, required this.serviceDate});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String,
      serviceDate: DateTime.parse(json['service_date'] as String),
    );
  }
}

