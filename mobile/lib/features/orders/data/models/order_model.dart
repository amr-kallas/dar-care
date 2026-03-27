// Placeholder for OrderModel
// Will need to create a proper model
class OrderModel {
  final String id;
  final String status;
  final DateTime serviceDate;
  // ... other fields

  OrderModel({required this.id, required this.status, required this.serviceDate});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      status: json['status'] as String,
      serviceDate: DateTime.parse((json['scheduled_at'] ?? json['service_date']) as String),
    );
  }
}

