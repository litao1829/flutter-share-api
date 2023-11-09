class LoginModel {
  User? user;
  String? token;

  LoginModel({this.user, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? phone;
  String? password;
  String? nickname;
  String? roles;
  String? avatarUrl;
  int? bonus;
  String? createTime;
  String? updateTime;

  User(
      {this.id,
        this.phone,
        this.password,
        this.nickname,
        this.roles,
        this.avatarUrl,
        this.bonus,
        this.createTime,
        this.updateTime});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    password = json['password'];
    nickname = json['nickname'];
    roles = json['roles'];
    avatarUrl = json['avatarUrl'];
    bonus = json['bonus'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['nickname'] = this.nickname;
    data['roles'] = this.roles;
    data['avatarUrl'] = this.avatarUrl;
    data['bonus'] = this.bonus;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}