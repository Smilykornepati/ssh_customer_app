import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPropertyType = 'Co-Living';
  String? _selectedLocation;
  int _adults = 1;
  int _children = 0;
  DateTime? _checkInDate;
  String? _selectedDuration;

  final List<String> _propertyTypes = ['Co-Living', 'Hotel'];
  
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

  List<String> _getDurationOptions() {
    if (_selectedPropertyType == 'Co-Living') {
      return ['1 day', '5 days', '10 days'];
    } else {
      return ['3 hours', '6 hours', '9 hours'];
    }
  }

  DateTime? _calculateCheckOutDate() {
    if (_checkInDate == null || _selectedDuration == null) return null;

    if (_selectedPropertyType == 'Co-Living') {
      final days = int.parse(_selectedDuration!.split(' ')[0]);
      return _checkInDate!.add(Duration(days: days));
    } else {
      final hours = int.parse(_selectedDuration!.split(' ')[0]);
      return _checkInDate!.add(Duration(hours: hours));
    }
  }

  int _calculateHours() {
    final checkOut = _calculateCheckOutDate();
    if (_checkInDate == null || checkOut == null) return 0;
    return checkOut.difference(_checkInDate!).inHours;
  }

  void _selectCheckInDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
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
          _checkInDate = DateTime(
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
        SnackBar(
          content: const Text('Please select a location'),
          backgroundColor: const Color(0xFFE31E24),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select check-in date'),
          backgroundColor: const Color(0xFFE31E24),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select duration'),
          backgroundColor: const Color(0xFFE31E24),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_adults + _children == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one guest'),
          backgroundColor: const Color(0xFFE31E24),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final checkOut = _calculateCheckOutDate()!;
    final hours = _calculateHours();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          propertyType: _selectedPropertyType,
          location: _selectedLocation!,
          adults: _adults,
          children: _children,
          fromDate: _checkInDate!,
          toDate: checkOut,
          hours: hours,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _calculateHours();
    final checkOut = _calculateCheckOutDate();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'SSH Hotels',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Color(0xFFE31E24), size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find Your',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF374151),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Perfect ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Stay',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE31E24),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Book properties by the hour or day',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Property Type',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: _propertyTypes.map((type) {
                        final isSelected = _selectedPropertyType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPropertyType = type;
                                _selectedDuration = null; // Reset duration when changing property type
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: type == _propertyTypes.last ? 0 : 10),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE31E24) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFE31E24) : const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    type == 'Co-Living'
                                        ? Icons.apartment_rounded
                                        : Icons.hotel_rounded,
                                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF6B7280),
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
                    const SizedBox(height: 24),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedLocation,
                            menuMaxHeight: 300,
                            borderRadius: BorderRadius.circular(16),
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Color(0xFF9CA3AF), size: 20),
                                  SizedBox(width: 12),
                                  Text('Select location', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)),
                                ],
                              ),
                            ),
                            selectedItemBuilder: (BuildContext context) {
                              return _locations.map((String location) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color(0xFFE31E24), size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          location,
                                          style: const TextStyle(
                                            color: Color(0xFF374151),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B7280)),
                            ),
                            dropdownColor: Colors.white,
                            elevation: 8,
                            items: _locations.map((String location) {
                              return DropdownMenuItem<String>(
                                value: location,
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Color(0xFFE31E24), size: 18),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: const TextStyle(
                                          color: Color(0xFF374151),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
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
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Guests',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.person_outline_rounded, color: Color(0xFFE31E24), size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Adults',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _adults > 1 ? const Color(0xFFE31E24) : const Color(0xFFE5E7EB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_adults > 1) {
                                          setState(() {
                                            _adults--;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove_rounded, color: Colors.white, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                  ),
                                  Container(
                                    width: 45,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_adults',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE31E24),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _adults++;
                                        });
                                      },
                                      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.child_care_rounded, color: Color(0xFFE31E24), size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Children',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _children > 0 ? const Color(0xFFE31E24) : const Color(0xFFE5E7EB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_children > 0) {
                                          setState(() {
                                            _children--;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove_rounded, color: Colors.white, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                  ),
                                  Container(
                                    width: 45,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_children',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE31E24),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _children++;
                                        });
                                      },
                                      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Check-in Date & Time',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _selectCheckInDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 20, color: Color(0xFFE31E24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _checkInDate != null
                                        ? DateFormat('dd MMM yyyy').format(_checkInDate!)
                                        : 'Select check-in date',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _checkInDate != null ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _checkInDate != null ? DateFormat('hh:mm a').format(_checkInDate!) : 'Select time',
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _getDurationOptions().map((duration) {
                        final isSelected = _selectedDuration == duration;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDuration = duration;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE31E24) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFE31E24) : const Color(0xFFE5E7EB),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              duration,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (checkOut != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFE4E6), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE31E24).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.logout_rounded, color: Color(0xFFE31E24), size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Check-out',
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat('dd MMM yyyy, hh:mm a').format(checkOut),
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
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.schedule_rounded, color: Color(0xFFE31E24), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Total: ${hours > 24 ? '${(hours / 24).floor()} day${(hours / 24).floor() > 1 ? 's' : ''} ${hours % 24 > 0 ? '${hours % 24}h' : ''}' : '$hours hour${hours > 1 ? 's' : ''}'}',
                                    style: const TextStyle(
                                      color: Color(0xFFE31E24),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _searchProperties,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31E24),
                          foregroundColor: Colors.white,
                          shadowColor: const Color(0xFFE31E24).withOpacity(0.3),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_rounded, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Search Properties',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}