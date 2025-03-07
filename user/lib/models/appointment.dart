import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final Map<String, dynamic> post;
  final String userID;
  final String companyID;
  final String userName;
  final String userPhone;
  final String userEmail;
  final int peopleCount;
  final String? note;
  final Timestamp createdAt;

  const Appointment({
    required this.id,
    required this.post,
    required this.userID,
    required this.companyID,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.peopleCount,
    this.note,
    required this.createdAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map, String documentID) {
    return Appointment(
      id: documentID,
      post: map['post'],
      userID: map['userID'],
      companyID: map['companyID'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      userEmail: map['userEmail'],
      peopleCount: map['peopleCount'],
      note: map['note'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post': post,
      'userID': userID,
      'companyID': companyID,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'peopleCount': peopleCount,
      'note': note,
      'createdAt': createdAt,
    };
  }

  Appointment copyWith({
    Map<String, dynamic>? post,
    String? userID,
    String? companyID,
    String? userName,
    String? userPhone,
    String? userEmail,
    int? peopleCount,
    String? note,
    Timestamp? createdAt,
  }) {
    return Appointment(
      id: id,
      post: post ?? this.post,
      userID: userID ?? this.userID,
      companyID: companyID ?? this.companyID,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userEmail: userEmail ?? this.userEmail,
      peopleCount: peopleCount ?? this.peopleCount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, post, userID, companyID, userName, userPhone, userEmail, peopleCount, note, createdAt];
}
