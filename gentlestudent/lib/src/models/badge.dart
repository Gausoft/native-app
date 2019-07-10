import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String openBadgeId;
  final String image;
  final String description;

  Badge({
    this.openBadgeId,
    this.image,
    this.description,
  });

  factory Badge.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Badge(
      openBadgeId: snapshot.documentID,
      image: data['image'],
      description: data['description'],
    );
  }
}
