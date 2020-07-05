import 'package:hive/hive.dart';

class User {
  String dateOfBirth;
  // bool isLoggedin;
  String userId;
  String color;
  String gender;
  String sexualOrintation;

  User(
      {this.color,
      this.userId,
      this.gender,
      this.dateOfBirth,
      this.sexualOrintation});
  User.fromMap(Map map) {
    this.userId = map['userId'];
    this.color = map['color'];
    this.gender = map['gender'];
    this.dateOfBirth = map['dateOfBirth'];
    this.sexualOrintation = map['sexualOrintation'];
  }
  Map toMap() {
    Map map = {};
    // this.isLoggedin = map['isLoggedin'];
    map['userId'] = this.userId;
    map['color'] = this.color;
    map['gender'] = this.gender;
    map['dateOfBirth'] = this.dateOfBirth;
    map['sexualOrintation'] = this.sexualOrintation;
    return map;
  }
}

@HiveType(typeId: 1)
class UserHive {
  @HiveField(0)
  String userId;
  @HiveField(1)
  String dateOfBirth;
  @HiveField(2)
  bool isLoggedin;
  @HiveField(3)
  String color;
  @HiveField(4)
  String gender;
  @HiveField(5)
  String sexualOrintation;
}
