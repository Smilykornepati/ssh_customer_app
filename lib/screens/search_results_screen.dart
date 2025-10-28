import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/property_model.dart';
import 'property_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String propertyType;
  final String location;
  final int adults;
  final int children;
  final DateTime fromDate;
  final DateTime toDate;
  final int hours;

  const SearchResultsScreen({
    super.key,
    required this.propertyType,
    required this.location,
    required this.adults,
    required this.children,
    required this.fromDate,
    required this.toDate,
    required this.hours,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Property> _filteredProperties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() async {
    await Future.delayed(const Duration(seconds: 1));

    final allProperties = _getMockProperties();

    final filtered = allProperties.where((property) {
      return property.type == widget.propertyType &&
          property.location == widget.location &&
          property.maxCapacity >= (widget.adults + widget.children);
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      _isLoading = false;
    });
  }

  List<Property> _getMockProperties() {
    return [
      Property(
        id: '1',
        name: 'Luxury Beach Resort',
        type: 'Resort',
        location: 'Goa',
        pricePerHour: 500,
        rating: 4.8,
        maxCapacity: 4,
        amenities: ['Pool', 'Beach Access', 'Spa', 'Restaurant'],
        image: 'assets/images/resort.png',
        description: 'Luxurious beachfront resort with stunning views',
      ),
      Property(
        id: '2',
        name: 'Mountain Paradise Resort',
        type: 'Resort',
        location: 'Manali, Himachal Pradesh',
        pricePerHour: 450,
        rating: 4.7,
        maxCapacity: 6,
        amenities: ['Mountain View', 'Garden', 'Restaurant', 'Bonfire'],
        image: 'assets/images/resort.png',
        description: 'Serene mountain resort with beautiful landscapes',
      ),
      Property(
        id: '3',
        name: 'Royal Heritage Resort',
        type: 'Resort',
        location: 'Jaipur, Rajasthan',
        pricePerHour: 600,
        rating: 4.9,
        maxCapacity: 8,
        amenities: ['Heritage Property', 'Pool', 'Spa', 'Fine Dining'],
        image: 'assets/images/resort.png',
        description: 'Experience royal hospitality in heritage setting',
      ),
      Property(
        id: '4',
        name: 'Urban Co-Living Space',
        type: 'Co-Living',
        location: 'Mumbai, Maharashtra',
        pricePerHour: 200,
        rating: 4.5,
        maxCapacity: 2,
        amenities: ['WiFi', 'Kitchen', 'Workspace', 'Gym'],
        image: 'assets/images/coliving.png',
        description: 'Modern co-living space in the heart of the city',
      ),
      Property(
        id: '5',
        name: 'Tech Hub Co-Living',
        type: 'Co-Living',
        location: 'Bangalore, Karnataka',
        pricePerHour: 180,
        rating: 4.4,
        maxCapacity: 2,
        amenities: ['High-Speed WiFi', 'Coworking', 'Cafe', 'Events'],
        image: 'assets/images/coliving.png',
        description: 'Perfect for digital nomads and remote workers',
      ),
      Property(
        id: '6',
        name: 'Creative Hub Co-Living',
        type: 'Co-Living',
        location: 'Delhi, NCR',
        pricePerHour: 220,
        rating: 4.6,
        maxCapacity: 3,
        amenities: ['Art Studio', 'WiFi', 'Community Kitchen', 'Lounge'],
        image: 'assets/images/coliving.png',
        description: 'Vibrant community for creative professionals',
      ),
      Property(
        id: '7',
        name: 'Business Class Hotel',
        type: 'Hotel',
        location: 'Mumbai, Maharashtra',
        pricePerHour: 350,
        rating: 4.6,
        maxCapacity: 3,
        amenities: ['Conference Room', 'WiFi', 'Restaurant', 'Gym'],
        image: 'assets/images/hotel.png',
        description: 'Ideal for business travelers with modern amenities',
      ),
      Property(
        id: '8',
        name: 'City Center Hotel',
        type: 'Hotel',
        location: 'Delhi, NCR',
        pricePerHour: 300,
        rating: 4.5,
        maxCapacity: 4,
        amenities: ['Central Location', 'Restaurant', 'WiFi', 'Parking'],
        image: 'assets/images/hotel.png',
        description: 'Centrally located hotel with easy access',
      ),
      Property(
        id: '9',
        name: 'Grand Plaza Hotel',
        type: 'Hotel',
        location: 'Bangalore, Karnataka',
        pricePerHour: 400,
        rating: 4.7,
        maxCapacity: 4,
        amenities: ['Luxury Rooms', 'Spa', 'Restaurant', 'Pool'],
        image: 'assets/images/hotel.png',
        description: 'Premium hotel with world-class facilities',
      ),
      Property(
        id: '10',
        name: 'Heritage Grand Hotel',
        type: 'Hotel',
        location: 'Jaipur, Rajasthan',
        pricePerHour: 420,
        rating: 4.8,
        maxCapacity: 5,
        amenities: ['Heritage', 'Restaurant', 'Cultural Shows', 'Spa'],
        image: 'assets/images/hotel.png',
        description: 'Experience traditional hospitality in modern comfort',
      ),
    ];
  }

  double _calculateTotalPrice(double pricePerHour) {
    final basePrice = pricePerHour * widget.hours;
    final gst = basePrice * 0.18;
    return basePrice + gst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search Results',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE31E24).withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.propertyType == 'Resort'
                          ? Icons.beach_access
                          : widget.propertyType == 'Co-Living'
                              ? Icons.apartment
                              : Icons.hotel,
                      color: const Color(0xFFE31E24),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget.propertyType} in ${widget.location}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.adults} Adult${widget.adults > 1 ? 's' : ''}${widget.children > 0 ? ', ${widget.children} Child${widget.children > 1 ? 'ren' : ''}' : ''}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.hours} hour${widget.hours > 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${DateFormat('dd MMM, hh:mm a').format(widget.fromDate)} - ${DateFormat('dd MMM, hh:mm a').format(widget.toDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE31E24),
                    ),
                  )
                : _filteredProperties.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No properties found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Try adjusting your search criteria',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredProperties.length,
                        itemBuilder: (context, index) {
                          final property = _filteredProperties[index];
                          final totalPrice = _calculateTotalPrice(property.pricePerHour);
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailScreen(
                                    property: property,
                                    fromDate: widget.fromDate,
                                    toDate: widget.toDate,
                                    hours: widget.hours,
                                    adults: widget.adults,
                                    children: widget.children,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: const Color(0xFFE31E24).withOpacity(0.1),
                                      child: Image.asset(
                                        property.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              property.type == 'Resort'
                                                  ? Icons.beach_access
                                                  : property.type == 'Co-Living'
                                                      ? Icons.apartment
                                                      : Icons.hotel,
                                              size: 60,
                                              color: const Color(0xFFE31E24),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                property.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    size: 16,
                                                    color: Colors.amber,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    property.rating.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              property.location,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Icon(
                                              Icons.people,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Up to ${property.maxCapacity} guests',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: property.amenities.take(3).map((amenity) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE31E24).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                amenity,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFFE31E24),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '₹${property.pricePerHour}/hour',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '₹${totalPrice.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFFE31E24),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Total (incl. GST)',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PropertyDetailScreen(
                                                        property: property,
                                                        fromDate: widget.fromDate,
                                                        toDate: widget.toDate,
                                                        hours: widget.hours,
                                                        adults: widget.adults,
                                                        children: widget.children,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFE31E24),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'View Details',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

