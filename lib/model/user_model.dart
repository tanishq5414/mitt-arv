class UserModel {
  String? id;
  String? username;
  String? email;
  List<String>? roles;
  String? accessToken;

  UserModel({this.id, this.username, this.email, this.roles, this.accessToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roles = json['roles'].cast<String>();
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['roles'] = roles;
    data['accessToken'] = accessToken;
    return data;
  }
}
