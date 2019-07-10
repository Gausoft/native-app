import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationApi {
  Future addUserToFirestore(String firstName, String lastName, String education,
      String email, String userId) async {
    Map<String, dynamic> data = <String, dynamic>{
      "name": "$firstName $lastName",
      "institute": education,
      "email": email,
      "profilePicture": "",
      "favorites": List<String>(),
    };

    final DocumentReference documentReference =
        Firestore.instance.document("Participants/$userId");

    documentReference.setData(data).whenComplete(() {
      print("User added");
    }).catchError((e) => print(e));
  }
}
