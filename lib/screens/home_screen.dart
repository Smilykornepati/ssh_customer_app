import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPropertyType = 'Resort';
  String? _selectedLocation;
  int _adults = 1;
  int _children = 0;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _propertyTypes = ['Resort', 'Co-Living', 'Hotel'];
  
  final List<String> _locations = [
    'Mumbai, Maharashtra',
    'Delhi, NCR',
    'Bangalore, Karnataka',
    'Goa',
    'Jaipur, Rajasthan',
    'Manali, Himachal Pradesh',
    'Shimla, Himachal Pradesh',
    'Ooty, Tamil Nadu',
    'Udaipur, Rajasthan',
    'Pondicherry',
    'Kerala',
    'Kolkata, West Bengal',
    'Hyderabad, Telangana',
    'Chennai, Tamil Nadu',
    'Pune, Maharashtra',
  ];

  int _calculateHoursBetweenDates() {
    if (_fromDate == null || _toDate == null) return 0;
    return _toDate!.difference(_fromDate!).inHours;
  }

  void _selectFromDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE31E24),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFE31E24),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _fromDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
          }
        });
      }
    }
  }

  void _selectToDate() async {
    if (_fromDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in date first'),
          backgroundColor: Color(0xFFE31E24),
        ),
      );
      return;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate!.add(const Duration(days: 1)),
      firstDate: _fromDate!,
      lastDate: _fromDate!.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE31E24),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFE31E24),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _toDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _searchProperties() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location'),
          backgroundColor: Color(0xFFE31E24),
        ),
      );
      return;
    }

    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
          backgroundColor: Color(0xFFE31E24),
        ),
      );
      return;
    }

    if (_adults + _children == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one guest'),
          backgroundColor: Color(0xFFE31E24),
        ),
      );
      return;
    }

    final hours = _calculateHoursBetweenDates();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          propertyType: _selectedPropertyType,
          location: _selectedLocation!,
          adults: _adults,
          children: _children,
          fromDate: _fromDate!,
          toDate: _toDate!,
          hours: hours,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _calculateHoursBetweenDates();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/images/ssh_logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'SSH Hotels',
              style: TextStyle(
                color: Color(0xFFE31E24),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find Your Perfect',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'Short Stay',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE31E24),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Property Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: _propertyTypes.map((type) {
                  final isSelected = _selectedPropertyType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPropertyType = type;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE31E24) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFE31E24) : Colors.grey[300]!,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              type == 'Resort'
                                  ? Icons.beach_access
                                  : type == 'Co-Living'
                                      ? Icons.apartment
                                      : Icons.hotel,
                              color: isSelected ? Colors.white : Colors.grey[700],
                              size: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedLocation,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Select location'),
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                    items: _locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(location),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Number of Guests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Adults',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_adults > 1) {
                                  setState(() {
                                    _adults--;
                                  });
                                }
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: _adults > 1 ? const Color(0xFFE31E24) : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '$_adults',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _adults++;
                                });
                              },
                              icon: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE31E24),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Children',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_children > 0) {
                                  setState(() {
                                    _children--;
                                  });
                                }
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: _children > 0 ? const Color(0xFFE31E24) : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '$_children',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _children++;
                                });
                              },
                              icon: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE31E24),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check-in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _selectFromDate,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Color(0xFFE31E24),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _fromDate != null
                                          ? DateFormat('dd MMM').format(_fromDate!)
                                          : 'Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _fromDate != null
                                            ? Colors.black87
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _fromDate != null
                                      ? DateFormat('hh:mm a').format(_fromDate!)
                                      : 'Time',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check-out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _selectToDate,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Color(0xFFE31E24),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _toDate != null
                                          ? DateFormat('dd MMM').format(_toDate!)
                                          : 'Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _toDate != null
                                            ? Colors.black87
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _toDate != null
                                      ? DateFormat('hh:mm a').format(_toDate!)
                                      : 'Time',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (hours > 0) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE31E24).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFFE31E24),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total Duration: $hours hour${hours > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Color(0xFFE31E24),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _searchProperties,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31E24),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Search Properties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}