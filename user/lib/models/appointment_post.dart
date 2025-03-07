import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppointmentPost extends Equatable {
  final String id;
  final String title;
  final String companyName;
  final String companyID;
  final String? companyImage;
  final Timestamp start;
  final Map<String, dynamic> geo;
  final bool isVisible;
  final String category;
  final int personCount;

  const AppointmentPost({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyID,
    this.companyImage,
    required this.start,
    required this.geo,
    required this.isVisible,
    required this.category,
    required this.personCount,
  });

  factory AppointmentPost.fromMap(Map<String, dynamic> map, String documentID) {
    return AppointmentPost(
      id: documentID,
      title: map['title'],
      companyName: map['companyName'],
      companyID: map['companyID'],
      companyImage: map['companyImage'],
      start: map['start'],
      geo: map['geo'],
      isVisible: map['isVisible'],
      category: map['category'],
      personCount: map['personCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'companyName': companyName,
      'companyID': companyID,
      'companyImage': companyImage,
      'start': start,
      'geo': geo,
      'isVisible': isVisible,
      'category': category,
      'personCount': personCount,
    };
  }

  AppointmentPost copyWith({
    String? title,
    String? companyName,
    String? companyID,
    String? companyImage,
    Timestamp? start,
    Map<String, dynamic>? geo,
    bool? isVisible,
    String? category,
    int? personCount,
  }) {
    return AppointmentPost(
      id: id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      companyID: companyID ?? this.companyID,
      companyImage: companyImage ?? this.companyImage,
      start: start ?? this.start,
      geo: geo ?? this.geo,
      isVisible: isVisible ?? this.isVisible,
      category: category ?? this.category,
      personCount: personCount ?? this.personCount,
    );
  }

  @override
  List<Object?> get props => [id, title, companyName, companyID, companyImage, start, geo, isVisible, category, personCount];
}
