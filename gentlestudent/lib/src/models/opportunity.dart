import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/utils/firebase_utils.dart';
import 'enums/authority.dart';
import 'enums/category.dart';
import 'enums/difficulty.dart';

class Opportunity {
  final String opportunityId;
  final String title;
  final Difficulty difficulty;
  final Category category;
  final String opportunityImageUrl;
  final String shortDescription;
  final String longDescription;
  final DateTime beginDate;
  final DateTime endDate;
  final bool international;
  final String addressId;
  final String badgeId;
  final String issuerId;
  final String pinImageUrl;
  final int participations;
  final Authority authority;
  final String contact;
  final String website;

  Opportunity({
    this.opportunityId,
    this.title,
    this.difficulty,
    this.category,
    this.opportunityImageUrl,
    this.shortDescription,
    this.longDescription,
    this.beginDate,
    this.endDate,
    this.international,
    this.addressId,
    this.badgeId,
    this.issuerId,
    this.pinImageUrl,
    this.participations,
    this.authority,
    this.contact,
    this.website,
  });

  factory Opportunity.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Opportunity(
      opportunityId: snapshot.documentID,
      beginDate: DateTime.parse(data['beginDate']),
      category: FirebaseUtils.dataToCategory(data['category']),
      difficulty: FirebaseUtils.dataToDifficulty(data['difficulty']),
      endDate: DateTime.parse(data['endDate']),
      international: data['international'],
      longDescription: data['longDescription'],
      opportunityImageUrl: data['oppImageUrl'],
      shortDescription: data['shortDescription'],
      title: data['title'],
      addressId: data['addressId'],
      badgeId: data['badgeId'],
      issuerId: data['issuerId'],
      pinImageUrl: data['pinImageUrl'],
      participations: data['participations'],
      authority: FirebaseUtils.dataToAuthority(data['authority']),
      contact: data['contact'],
      website: data['website'],
    );
  }
}