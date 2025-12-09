import 'package:flutter/material.dart';
import '../models/property_model.dart';
import 'property_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Property> _favorites = [
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
  ];

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from favorites'),
        backgroundColor: const Color(0xFFE31E24),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(label: 'Undo', textColor: Colors.white, onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Favorites', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text('No Favorites Yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Text('Start adding properties to your favorites', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final property = _favorites[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              color: const Color(0xFFE31E24).withOpacity(0.1),
                              child: Image.asset(
                                property.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.beach_access, size: 50, color: Color(0xFFE31E24)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => _removeFavorite(index),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.favorite, color: Color(0xFFE31E24), size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(property.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(property.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(property.location, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('₹${property.pricePerHour}/hour', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE31E24))),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EnhancedPropertyDetailScreen(
                                          property: property,
                                          fromDate: DateTime.now(),
                                          toDate: DateTime.now().add(const Duration(hours: 6)),
                                          hours: 6,
                                          adults: 1,
                                          children: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE31E24),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}