import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  final String id;
  final String title;
  final String description;
  final String companyName;
  final String companyID;
  final String? companyImage;
  final Timestamp start;
  final Timestamp end;
  final Map<String, dynamic> geo;
  final bool isVisible;
  final String category;
  final String productName;
  final String? image;
  final List<String> multipleImages;
  final String? menuLink;
  final String? yemeksepetiLink;
  final String? getirLink;
  final bool freezed;

  Campaign({
    this.id = '',
    required this.title,
    required this.description,
    required this.companyName,
    required this.companyID,
    this.companyImage,
    required this.start,
    required this.end,
    required this.geo,
    required this.isVisible,
    required this.category,
    required this.productName,
    this.image,
    this.multipleImages = const [],
    this.menuLink,
    this.yemeksepetiLink,
    this.getirLink,
    this.freezed = false,
  });

  factory Campaign.fromMap(Map<String, dynamic> map, String documentID) {
    return Campaign(
      id: documentID,
      title: map['title'],
      description: map['description'],
      companyName: map['companyName'],
      companyID: map['companyID'],
      companyImage: map['companyImage'],
      start: map['start'],
      end: map['end'],
      geo: map['geo'],
      isVisible: map['isVisible'],
      category: map['category'] ?? '',
      productName: map['productName'] ?? '',
      image: map['image'],
      multipleImages: map['multipleImages'] != null ? List<String>.from(map['multipleImages']) : [],
      menuLink: map['menuLink'],
      yemeksepetiLink: map['yemeksepetiLink'],
      getirLink: map['getirLink'],
      freezed: map['freezed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'companyName': companyName,
      'companyID': companyID,
      'companyImage': companyImage,
      'start': start,
      'end': end,
      'geo': geo,
      'isVisible': isVisible,
      'category': category,
      'productName': productName,
      'image': image,
      'multipleImages': multipleImages,
      'menuLink': menuLink,
      'yemeksepetiLink': yemeksepetiLink,
      'getirLink': getirLink,
      'freezed': freezed,
    };
  }

  Campaign copyWith({
    String? title,
    String? description,
    String? companyName,
    String? companyID,
    String? companyImage,
    Timestamp? start,
    Timestamp? end,
    Map<String, dynamic>? geo,
    bool? isVisible,
    String? category,
    String? productName,
    String? image,
    List<String>? multipleImages,
    String? menuLink,
    String? yemeksepetiLink,
    String? getirLink,
    bool? freezed,
  }) {
    return Campaign(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      companyName: companyName ?? this.companyName,
      companyID: companyID ?? this.companyID,
      companyImage: companyImage ?? this.companyImage,
      start: start ?? this.start,
      end: end ?? this.end,
      geo: geo ?? this.geo,
      isVisible: isVisible ?? this.isVisible,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      image: image ?? this.image,
      multipleImages: multipleImages ?? this.multipleImages,
      menuLink: menuLink ?? this.menuLink,
      yemeksepetiLink: yemeksepetiLink ?? this.yemeksepetiLink,
      getirLink: getirLink ?? this.getirLink,
      freezed: freezed ?? this.freezed,
    );
  }

  @override
  List<Object?> get props => [id, title, description, companyName, companyID, companyImage, start, end, geo, isVisible, category, productName, freezed];

  @override
  String toString() =>
      'Campaign(id: $id, title: $title, description: $description, companyName: $companyName, companyID: $companyID, start: $start, end: $end, geo: $geo, isVisible: $isVisible, category: $category)';
}
