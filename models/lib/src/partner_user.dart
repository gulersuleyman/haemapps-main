import 'package:equatable/equatable.dart';

class PartnerUser extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final Map<String, dynamic>? geo;
  final bool approved;
  final String? menuLink;
  final String? yemeksepetiLink;
  final String? getirLink;
  final String? category;

  PartnerUser({
    this.id = '',
    required this.name,
    this.imageUrl,
    this.geo,
    this.approved = false,
    this.menuLink,
    this.yemeksepetiLink,
    this.getirLink,
    this.category,
  });

  factory PartnerUser.fromMap(Map<String, dynamic> map, String documentID) {
    return PartnerUser(
      id: documentID,
      name: map['name'],
      imageUrl: map['imageUrl'],
      geo: map['geo'],
      approved: map['approved'] ?? false,
      menuLink: map['menuLink'],
      yemeksepetiLink: map['yemeksepetiLink'],
      getirLink: map['getirLink'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'geo': geo,
      'approved': approved,
      'menuLink': menuLink,
      'yemeksepetiLink': yemeksepetiLink,
      'getirLink': getirLink,
      'category': category,
    };
  }

  PartnerUser copyWith({
    String? id,
    String? name,
    String? imageUrl,
    Map<String, dynamic>? geo,
    bool? approved,
    String? menuLink,
    String? yemeksepetiLink,
    String? getirLink,
    String? category,
  }) {
    return PartnerUser(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      geo: geo ?? this.geo,
      approved: approved ?? this.approved,
      menuLink: menuLink ?? this.menuLink,
      yemeksepetiLink: yemeksepetiLink ?? this.yemeksepetiLink,
      getirLink: getirLink ?? this.getirLink,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, geo, approved, menuLink, yemeksepetiLink, getirLink, category];
}
