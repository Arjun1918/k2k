import 'dart:convert';

ProjectResponse projectResponseFromJson(String str) =>
    ProjectResponse.fromJson(json.decode(str));

String projectResponseToJson(ProjectResponse data) =>
    json.encode(data.toJson());

class ProjectResponse {
  final int statusCode;
  final bool success;
  final String message;
  final List<Project> data;

  ProjectResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      ProjectResponse(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: List<Project>.from(
            json["data"].map((x) => Project.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Project {
  final String id;
  final String name;
  final Client client;
  final String address;
  final bool isDeleted;
  final CreatedBy createdBy;
  final String createdAt;
  final String updatedAt;
  final int v;

  Project({
    required this.id,
    required this.name,
    required this.client,
    required this.address,
    required this.isDeleted,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["_id"],
        name: json["name"],
        client: Client.fromJson(json["client"]),
        address: json["address"],
        isDeleted: json["isDeleted"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "client": client.toJson(),
        "address": address,
        "isDeleted": isDeleted,
        "created_by": createdBy.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Client {
  final String id;
  final String name;
  final String address;

  Client({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["_id"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
      };
}

class CreatedBy {
  final String id;
  final String email;
  final String username;

  CreatedBy({
    required this.id,
    required this.email,
    required this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        email: json["email"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "username": username,
      };
}
