import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final List<dynamic> favorites;
  final String? name;
  final String? phone;
  final String? address;

  AppUser({
    this.id = '',
    required this.email,
    required this.favorites,
    this.name,
    this.phone,
    this.address,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String documentID) {
    return AppUser(
      id: documentID,
      email: map['email'],
      favorites: map['favorites'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'favorites': favorites,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    List<dynamic>? favorites,
    String? name,
    String? phone,
    String? address,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      favorites: favorites ?? this.favorites,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, email, favorites, name, phone, address];

  @override
  String toString() => 'AppUser(id: $id, email: $email, favorites: $favorites)';
}
