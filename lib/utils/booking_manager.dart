import '../models/booking_model.dart';

class BookingManager {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  final List<BookingModel> _bookings = [];

  void addBooking(BookingModel booking) {
    _bookings.add(booking);
  }

  List<BookingModel> getBookings(String status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  List<BookingModel> getAllBookings() {
    return List.from(_bookings);
  }

  void clearBookings() {
    _bookings.clear();
  }
}