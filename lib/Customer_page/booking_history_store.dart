import 'package:flutter/material.dart';

class BookingHistoryEntry {
  final String bookingRef;
  final String salonName;
  final String serviceTitle;
  final String serviceDuration;
  final String staffName;
  final String customerName;
  final String dateLabel;
  final String timeLabel;
  final String paymentMethod;
  final double total;
  final IconData serviceIcon;
  final Color accentColor;
  final DateTime bookedAt;

  const BookingHistoryEntry({
    required this.bookingRef,
    required this.salonName,
    required this.serviceTitle,
    required this.serviceDuration,
    required this.staffName,
    required this.customerName,
    required this.dateLabel,
    required this.timeLabel,
    required this.paymentMethod,
    required this.total,
    required this.serviceIcon,
    required this.accentColor,
    required this.bookedAt,
  });
}

class BookingHistoryStore extends ChangeNotifier {
  BookingHistoryStore._();

  static final BookingHistoryStore instance = BookingHistoryStore._();

  final List<BookingHistoryEntry> _bookings = [];

  List<BookingHistoryEntry> get bookings =>
      List.unmodifiable(_bookings.reversed);

  void addBooking(BookingHistoryEntry booking) {
    _bookings.add(booking);
    notifyListeners();
  }
}
