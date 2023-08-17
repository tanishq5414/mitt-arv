class UserModel {
  String? id;
  String? username;
  String? email;
  String? profilePic;
  List<String>? roles;
  String? accessToken;
  List<String>? fav;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.profilePic,
      this.roles,
      this.accessToken,
      this.fav});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    email = json['email'];
    profilePic = json['profilePic'];
    roles = json['roles'].cast<String>();
    accessToken = json['accessToken'];
    if (json['favs'] != null) {
      fav = List<String>.from(json['favs'].cast<String>());
    } else {
      fav = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['profilePic'] = profilePic;
    data['roles'] = roles;
    data['accessToken'] = accessToken;
    data['favs'] = fav;
    return data;
  }
}
