import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> awardBadge(String badgeId, String badgeName, String badgeDescription, String imageUrl) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  final badgeRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .collection('badges')
      .doc(badgeId);

  final doc = await badgeRef.get();
  if (!doc.exists) {
    await badgeRef.set({
      'name': badgeName,
      'description': badgeDescription,
      'imageUrl': imageUrl,
      'isEarned': true,
    });
  }
}
