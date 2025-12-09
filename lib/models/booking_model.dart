import 'property_model.dart';

class BookingModel {
  final String id;
  final Property property;
  final DateTime fromDate;
  final DateTime toDate;
  final int adults;
  final int children;
  final int hours;
  final double totalPrice;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final DateTime bookingDate;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String? paymentId;

  BookingModel({
    required this.id,
    required this.property,
    required this.fromDate,
    required this.toDate,
    required this.adults,
    required this.children,
    required this.hours,
    required this.totalPrice,
    required this.status,
    required this.bookingDate,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    this.paymentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property': property.toJson(),
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'adults': adults,
      'children': children,
      'hours': hours,
      'totalPrice': totalPrice,
      'status': status,
      'bookingDate': bookingDate.toIso8601String(),
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'paymentId': paymentId,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      property: Property.fromJson(json['property']),
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      adults: json['adults'],
      children: json['children'],
      hours: json['hours'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      bookingDate: DateTime.parse(json['bookingDate']),
      guestName: json['guestName'],
      guestEmail: json['guestEmail'],
      guestPhone: json['guestPhone'],
      paymentId: json['paymentId'],
    );
  }
}