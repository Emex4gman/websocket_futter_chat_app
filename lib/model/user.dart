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
