import 'dart:convert';

class UserData {
  
  int id;
  final String nickname;
  final String username;
  final String password;
  final String email;
  int isFirstTime;

  UserData({
    this.id,
    this.nickname,
    this.username,
    this.password,
    this.email,
    this.isFirstTime = 1,
  });


  UserData copyWith({
    int id,
    String nickname,
    String username,
    String password,
    String email,
    int isFirstTime,
  }) {
    return UserData(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'username': username,
      'password': password,
      'email': email,
      'first_time': isFirstTime,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserData(
      id: map['id'],
      nickname: map['nickname'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      isFirstTime: map['first_time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(id: $id, nickname: $nickname, username: $username, password: $password, email: $email, isFirstTime: $isFirstTime)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserData &&
      o.id == id &&
      o.nickname == nickname &&
      o.username == username &&
      o.password == password &&
      o.email == email &&
      o.isFirstTime == isFirstTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nickname.hashCode ^
      username.hashCode ^
      password.hashCode ^
      email.hashCode ^
      isFirstTime.hashCode;
  }
}
