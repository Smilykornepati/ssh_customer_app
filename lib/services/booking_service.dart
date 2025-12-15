import 'package:flutter/foundation.dart';
import './api_service.dart';
import '../models/booking_model.dart';

class BookingService with ChangeNotifier {
  List<BookingModel> _allBookings = [];
  bool _isLoading = false;
  
  List<BookingModel> get allBookings => _allBookings;
  bool get isLoading => _isLoading;
  
  // Get bookings by status
  List<BookingModel> getBookingsByStatus(String status) {
    return _allBookings.where((b) => b.status == status).toList();
  }
  
  // Create new booking
  Future<BookingModel> createBooking({
    required String propertyId,
    required String propertyName,
    required String propertyType,
    required String propertyLocation,
    required String propertyImage,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int hours,
    required int adults,
    required int children,
    required double basePrice,
    required double gstAmount,
    required double totalPrice,
    required String paymentId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await apiService.dio.post('/bookings', data: {
        'property_id': propertyId,
        'property_name': propertyName,
        'property_type': propertyType,
        'property_location': propertyLocation,
        'property_image': propertyImage,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'hours': hours,
        'adults': adults,
        'children': children,
        'base_price': basePrice,
        'gst_amount': gstAmount,
        'total_price': totalPrice,
        'payment_id': paymentId,
        'payment_status': 'completed',
        'guest_name': guestName,
        'guest_email': guestEmail,
        'guest_phone': guestPhone,
      });
      
      if (response.statusCode == 201) {
        final booking = BookingModel.fromJson(response.data['data']);
        _allBookings.insert(0, booking);
        _isLoading = false;
        notifyListeners();
        return booking;
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  // Fetch all bookings
  Future<void> fetchBookings() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await apiService.dio.get('/bookings');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _allBookings = data.map((json) => BookingModel.fromJson(json)).toList();
        
        // Sort by check-in date (newest first)
        _allBookings.sort((a, b) => b.fromDate.compareTo(a.fromDate));
        
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  // Fetch bookings by status
  Future<List<BookingModel>> fetchBookingsByStatus(String status) async {
    try {
      final response = await apiService.dio.get('/bookings/status/$status');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BookingModel.fromJson(json)).toList();
      }
      return [];
    } catch (error) {
      rethrow;
    }
  }
  
  // Get single booking
  Future<BookingModel> getBookingById(int bookingId) async {
    try {
      final response = await apiService.dio.get('/bookings/$bookingId');
      
      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception('Booking not found');
      }
    } catch (error) {
      rethrow;
    }
  }
  
  // Cancel booking
  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    try {
      final response = await apiService.dio.put('/bookings/$bookingId/cancel');
      
      if (response.statusCode == 200) {
        // Update local booking status
        final index = _allBookings.indexWhere((b) => b.id == bookingId.toString());
        if (index != -1) {
          _allBookings[index] = BookingModel.fromJson(response.data['data']['booking']);
          notifyListeners();
        }
        
        return response.data['data'];
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (error) {
      rethrow;
    }
  }
  
  // Get booking statistics
  Future<Map<String, dynamic>> getBookingStats() async {
    try {
      final response = await apiService.dio.get('/bookings/stats');
      
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      return {};
    } catch (error) {
      rethrow;
    }
  }
  
  // Clear bookings (for logout)
  void clearBookings() {
    _allBookings = [];
    notifyListeners();
  }
}

// Singleton instance
final bookingService = BookingService();