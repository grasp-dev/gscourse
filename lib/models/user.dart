class User {
  int? id;
  int? cousrId;
  String? username;
  String? name;
  String? email;
  String? profile;
  String? token;

  User({
    this.id,
    this.cousrId,
    this.username,
    this.name,
    this.email,
    this.profile,
    this.token,
  });

  factory User.formJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      cousrId: json['user']['course_id'],
      username: json['user']['username'],
      name: json['user']['name'],
      email: json['user']['email'],
      profile: json['user']['profile'],
      token: json['token'],
    );
  }
}
