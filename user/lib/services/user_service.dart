import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userID = EpiFirebaseAuth.instance.currentUser!.uid;

  Future<EpiResponse<String?>> addCampaignToFavorites(String campaignID) async {
    try {
      await firestore.collection('users').doc(userID).update({
        'favorites': FieldValue.arrayUnion([campaignID]),
      });
      return EpiResponse.success('Campaign added to favorites');
    } on FirebaseException catch (e) {
      return EpiResponse.error(e.message.toString());
    } catch (e) {
      return EpiResponse.error('An error occurred');
    }
  }

  Future<EpiResponse<String?>> removeCampaignFromFavorites(String campaignID) async {
    try {
      await firestore.collection('users').doc(userID).update({
        'favorites': FieldValue.arrayRemove([campaignID]),
      });
      return EpiResponse.success('Campaign removed from favorites');
    } on FirebaseException catch (e) {
      return EpiResponse.error(e.message.toString());
    } catch (e) {
      return EpiResponse.error('An error occurred');
    }
  }
}
