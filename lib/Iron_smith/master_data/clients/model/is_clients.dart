class ClientsResponse {
  int? statusCode;
  bool? success;
  String? message;
  List<Client>? clients;

  ClientsResponse({
    this.statusCode,
    this.success,
    this.message,
    this.clients,
  });

  factory ClientsResponse.fromJson(Map<String, dynamic> json) {
    return ClientsResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      clients: (json['data']?['clients'] as List<dynamic>?)
          ?.map((e) => Client.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'clients': clients?.map((e) => e.toJson()).toList(),
    };
  }
}

class Client {
  String? id;
  String? name;
  String? address;
  bool? isDeleted;
  CreatedBy? createdBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  Client({
    this.id,
    this.name,
    this.address,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      isDeleted: json['isDeleted'],
      createdBy: json['created_by'] != null
          ? CreatedBy.fromJson(json['created_by'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'isDeleted': isDeleted,
      'created_by': createdBy?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class CreatedBy {
  String? id;
  String? email;
  String? username;

  CreatedBy({
    this.id,
    this.email,
    this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'username': username,
    };
  }
  
}

