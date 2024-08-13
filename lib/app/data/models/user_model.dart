class UserModel {
  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  List receivedItems = [];

  UserModel({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.id,
    this.receivedItems = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'id': id,
      'receivedItems': receivedItems
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      id: json['id'],
      receivedItems: json['receivedItems'],
    );
  }
}
