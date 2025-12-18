import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePlace {
  final String id; // Firestore doc id
  final String placeId;
  final String name;
  final double rating;
  final String address;
  final String imageUrl;
  final String preview;
  final String createdBy;
  final DateTime createdAt;

  FavoritePlace({
    required this.id,
    required this.placeId,
    required this.name,
    required this.rating,
    required this.address,
    required this.imageUrl,
    required this.preview,
    required this.createdBy,
    required this.createdAt,
  });

  /// Convert Dart object -> Firestore map
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'name': name,
      'rating': rating,
      'address': address,
      'imageUrl': imageUrl,
      'preview': preview,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Convert Firestore document -> Dart object
  factory FavoritePlace.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return FavoritePlace(
      id: doc.id,
      placeId: data['placeId'],
      name: data['name'],
      rating: (data['rating'] as num).toDouble(),
      address: data['address'],
      imageUrl: data['imageUrl'],
      preview: data['preview'] ?? '',
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}