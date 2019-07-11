import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/utils/firebase_utils.dart';

class Participation {
  final String participationId;
  final String participantId;
  final String opportunityId;
  final String reason;
  Status status;

  Participation({
    this.participationId,
    this.participantId,
    this.opportunityId,
    this.reason,
    this.status,
  });

  static Participation fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Participation(
      participationId: snapshot.documentID,
      participantId: data['participantId'],
      opportunityId: data['opportunityId'],
      reason: data['reason'],
      status: FirebaseUtils.dataToStatus(
        data['status'],
      ),
    );
  }
}
