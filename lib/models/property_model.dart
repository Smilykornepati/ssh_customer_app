class Property {
  final String id;
  final String name;
  final String type;
  final String location;
  final double pricePerHour;
  final double rating;
  final int maxCapacity;
  final List<String> amenities;
  final String image;
  final String description;

  Property({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.pricePerHour,
    required this.rating,
    required this.maxCapacity,
    required this.amenities,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'pricePerHour': pricePerHour,
      'rating': rating,
      'maxCapacity': maxCapacity,
      'amenities': amenities,
      'image': image,
      'description': description,
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'],
      pricePerHour: json['pricePerHour'].toDouble(),
      rating: json['rating'].toDouble(),
      maxCapacity: json['maxCapacity'],
      amenities: List<String>.from(json['amenities']),
      image: json['image'],
      description: json['description'],
    );
  }
}

class Booking {
  final String id;
  final Property property;
  final DateTime fromDate;
  final DateTime toDate;
  final int adults;
  final int children;
  final int hours;
  final double totalPrice;
  final String status;
  final DateTime bookingDate;

  Booking({
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
  });
}
