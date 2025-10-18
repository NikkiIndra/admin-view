class UserModel {
  int? id;
  String? name;
  String? email;
  String? rt;
  String? rw;
  String? blok;
  String? role;
  String? createdAt;
  String? phone;
  int? desa_id;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.rt,
    this.rw,
    this.blok,
    this.role,
    this.createdAt,
    this.phone,
    this.desa_id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['rt'] = rt;
    data['rw'] = rw;
    data['blok'] = blok;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['phone'] = phone;
    data['desa_id'] = desa_id;
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['nama_lengkap'],
      email: json['email'],
      rt: json['rt'],
      rw: json['rw'],
      blok: json['blok'],
      role: json['role'],
      phone: json['phone'],
      desa_id: json['desa_id'],
    );
  }
}
