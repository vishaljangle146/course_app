import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'booking_details_screen.dart'; // Import the BookingDetailsScreen

class InterviewBookingScreen extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final double rating;

  InterviewBookingScreen({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
  });

  @override
  _InterviewBookingScreenState createState() => _InterviewBookingScreenState();
}

class _InterviewBookingScreenState extends State<InterviewBookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<DateTime> _availableDates = [];
  List<DateTime> _disabledDates = [];
  List<TimeOfDay> _availableTimeSlots = [];
  List<TimeOfDay> _allTimeSlots = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
  ];

  List<DateTime> _nationalHolidays = [
    DateTime(2024, 1, 1), // New Year's Day
    DateTime(2024, 7, 4), // Independence Day
    DateTime(2024, 12, 25), // Christmas Day
  ];

  final Random _random = Random();
  bool _isTodayAvailable = false;

  Map<DateTime, List<TimeOfDay>> _generatedTimeSlots = {}; // Map to store fixed time slots per date

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
    _generateDisabledDates();
  }

  void _generateAvailableDates() {
    DateTime now = DateTime.now();
    DateTime endOfNextMonth = DateTime(now.year, now.month + 2, 0);

    for (DateTime date = now; date.isBefore(endOfNextMonth); date = date.add(Duration(days: 1))) {
      if (_random.nextBool()) {
        _availableDates.add(date);
      }
    }

    _updateTodayAvailability();
  }

  void _generateDisabledDates() {
    DateTime now = DateTime.now();
    DateTime endOfNextMonth = DateTime(now.year, now.month + 2, 0);

    for (DateTime date = now; date.isBefore(endOfNextMonth); date = date.add(Duration(days: 1))) {
      if (_random.nextBool()) {
        _disabledDates.add(date);
      }
    }
  }

  void _generateAvailableTimeSlots(DateTime date) {
    if (!_generatedTimeSlots.containsKey(date)) {
      // Only generate if no slots have been generated for this date
      List<TimeOfDay> randomSlots = [];
      int randomSlotCount = _random.nextInt(_allTimeSlots.length) + 1; // Random number of slots

      Set<int> usedIndices = {};
      while (usedIndices.length < randomSlotCount) {
        int randomIndex = _random.nextInt(_allTimeSlots.length);
        if (!usedIndices.contains(randomIndex)) {
          randomSlots.add(_allTimeSlots[randomIndex]);
          usedIndices.add(randomIndex);
        }
      }

      _generatedTimeSlots[date] = randomSlots; // Store generated slots for this date
    }

    // Set available time slots to the already generated ones
    _availableTimeSlots = _generatedTimeSlots[date]!;
    setState(() {});
  }

  void _updateTodayAvailability() {
    DateTime today = DateTime.now();
    _isTodayAvailable = _availableDates.any((availableDate) => isSameDay(today, availableDate));
    setState(() {});
  }

  Future<void> _saveBooking(DateTime date, TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookingsJson = prefs.getStringList('bookings');
    final List<Booking> bookings =
        bookingsJson?.map((json) => Booking.fromJson(jsonDecode(json))).toList() ?? [];

    bookings.add(Booking(date: date, time: time));
    prefs.setStringList(
        'bookings', bookings.map((booking) => jsonEncode(booking.toJson())).toList());
  }

  void _showSelectionError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selection Required'),
        content: Text('Please select both a date and time to proceed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() async {
    if (_selectedDate != null && _selectedTime != null) {
      await _saveBooking(_selectedDate!, _selectedTime!);
      _generatedTimeSlots.remove(_selectedDate); // Clear slots for the booked date

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreen(
            title: widget.title,
            author: widget.author,
            price: widget.price,
            rating: widget.rating,
            date: _selectedDate!,
            time: _selectedTime!,
          ),
        ),
      );
    } else {
      _showSelectionError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Book Course'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your Session Slot',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Select a date to see available time slots:',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TableCalendar(
                        firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
                        lastDay: DateTime(DateTime.now().year, DateTime.now().month + 2, 0),
                        focusedDay: _selectedDate ?? DateTime.now(),
                        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _generateAvailableTimeSlots(selectedDay);
                            _selectedTime = null;
                          });
                        },
                        enabledDayPredicate: (day) {
                          return _availableDates.any((availableDate) => isSameDay(day, availableDate)) &&
                              !(_isWeekend(day) || _isNationalHoliday(day) || _isRandomlyDisabled(day)) ||
                              isSameDay(day, DateTime.now());
                        },
                        calendarStyle: CalendarStyle(
                          defaultDecoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 1,
                            ),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(0.5),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 2,
                            ),
                          ),
                          holidayDecoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          disabledDecoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          weekendDecoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedTextStyle: TextStyle(color: Colors.white),
                          todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          holidayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          disabledTextStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          weekendTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(Icons.arrow_left, color: Colors.black),
                          rightChevronIcon: Icon(Icons.arrow_right, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_availableTimeSlots.isNotEmpty) ...[
                    Text(
                      'Available Time Slots',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _availableTimeSlots.map((timeSlot) {
                        return ChoiceChip(
                          label: Text('${timeSlot.format(context)}'),
                          selected: _selectedTime == timeSlot,
                          selectedColor: Colors.deepPurple,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _selectedTime == timeSlot ? Colors.white : Colors.black,
                          ),
                          checkmarkColor: Colors.white,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTime = timeSlot;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 100), // Ensure space for the button
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shading color
                    blurRadius: 2, // Spread of the shadow
                    offset: Offset(0, -4), // Offset to place the shadow at the top
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Padding similar to EnrollmentButton
                child: ElevatedButton(
                  onPressed: () => _confirmBooking(), // Call your confirm booking function here
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 19, // Same font size as 'Buy Now' button
                      fontWeight: FontWeight.bold, // Same bold styling
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Same padding as 'Buy Now' button
                    backgroundColor: Colors.deepPurple, // Same deep purple background color
                    foregroundColor: Colors.white, // White text color
                    minimumSize: Size(330, 45), // Same size as 'Buy Now' button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0), // Same rounded edges
                      side: BorderSide(color: Colors.deepPurple.shade700, width: 2), // Same border style
                    ),
                    shadowColor: Colors.deepPurple.withOpacity(0.5), // Same shadow color
                    elevation: 5, // Same shadow elevation
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  bool _isNationalHoliday(DateTime day) {
    return _nationalHolidays.any((holiday) => isSameDay(day, holiday));
  }

  bool _isRandomlyDisabled(DateTime day) {
    return _disabledDates.any((disabledDate) => isSameDay(day, disabledDate));
  }
}

class Booking {
  final DateTime date;
  final TimeOfDay time;

  Booking({
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'time': '${time.hour}:${time.minute}',
  };
  static Booking fromJson(Map<String, dynamic> json) {
    return Booking(
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
    );
  }
}