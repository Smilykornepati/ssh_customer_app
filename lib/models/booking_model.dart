class BookingModel {
  final String id;
  final int userId;
  final String propertyId;
  final String propertyName;
  final String propertyType;
  final String propertyLocation;
  final String? propertyImage;
  final DateTime fromDate;
  final DateTime toDate;
  final int adults;
  final int children;
  final int hours;
  final double basePrice;
  final double gstAmount;
  final double totalPrice;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final String paymentStatus; // 'pending', 'completed', 'failed', 'refunded'
  final DateTime bookingDate;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String? paymentId;
  final DateTime? cancellationDate;
  final DateTime? updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.propertyName,
    required this.propertyType,
    required this.propertyLocation,
    this.propertyImage,
    required this.fromDate,
    required this.toDate,
    required this.adults,
    required this.children,
    required this.hours,
    required this.basePrice,
    required this.gstAmount,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.bookingDate,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    this.paymentId,
    this.cancellationDate,
    this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'].toString(),
      userId: json['user_id'] ?? 0,
      propertyId: json['property_id'] ?? '',
      propertyName: json['property_name'] ?? '',
      propertyType: json['property_type'] ?? '',
      propertyLocation: json['property_location'] ?? '',
      propertyImage: json['property_image'],
      fromDate: DateTime.parse(json['check_in_date']),
      toDate: DateTime.parse(json['check_out_date']),
      adults: json['adults'] ?? 1,
      children: json['children'] ?? 0,
      hours: json['hours'] ?? 0,
      basePrice: (json['base_price'] is String 
          ? double.parse(json['base_price']) 
          : json['base_price'] ?? 0).toDouble(),
      gstAmount: (json['gst_amount'] is String 
          ? double.parse(json['gst_amount']) 
          : json['gst_amount'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] is String 
          ? double.parse(json['total_price']) 
          : json['total_price'] ?? 0).toDouble(),
      status: json['booking_status'] ?? 'upcoming',
      paymentStatus: json['payment_status'] ?? 'pending',
      bookingDate: DateTime.parse(json['created_at']),
      guestName: json['guest_name'] ?? '',
      guestEmail: json['guest_email'] ?? '',
      guestPhone: json['guest_phone'] ?? '',
      paymentId: json['payment_id'],
      cancellationDate: json['cancellation_date'] != null
          ? DateTime.parse(json['cancellation_date'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'property_id': propertyId,
      'property_name': propertyName,
      'property_type': propertyType,
      'property_location': propertyLocation,
      'property_image': propertyImage,
      'check_in_date': fromDate.toIso8601String(),
      'check_out_date': toDate.toIso8601String(),
      'adults': adults,
      'children': children,
      'hours': hours,
      'base_price': basePrice,
      'gst_amount': gstAmount,
      'total_price': totalPrice,
      'booking_status': status,
      'payment_status': paymentStatus,
      'created_at': bookingDate.toIso8601String(),
      'guest_name': guestName,
      'guest_email': guestEmail,
      'guest_phone': guestPhone,
      'payment_id': paymentId,
      'cancellation_date': cancellationDate?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  // Helper method to check if booking is cancellable
  bool get isCancellable {
    if (status == 'cancelled' || status == 'completed') {
      return false;
    }
    return fromDate.isAfter(DateTime.now());
  }
  
  // Calculate refund percentage
  int get refundPercentage {
    if (!isCancellable) return 0;
    
    final hoursUntilCheckIn = fromDate.difference(DateTime.now()).inHours;
    if (hoursUntilCheckIn >= 24) {
      return 100;
    } else if (hoursUntilCheckIn > 0) {
      return 50;
    }
    return 0;
  }
  
  // Calculate refund amount
  double get refundAmount {
    return totalPrice * (refundPercentage / 100);
  }
}