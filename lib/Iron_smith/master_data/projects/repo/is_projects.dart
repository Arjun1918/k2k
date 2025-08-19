import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k2k/Iron_smith/master_data/projects/model/is_project_model.dart';
import 'package:k2k/api_services/api_services.dart';
import 'package:k2k/api_services/shared_preference/shared_preference.dart';

class ProjectsRepository {
  Future<Map<String, String>> get headers async {
    final token = await fetchAccessToken();
    if (token == null || token.isEmpty) {
      print('Authentication token is missing');
      throw Exception('Authentication token is missing');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Client>> fetchClients() async {
    try {
      final headers = await this.headers;
      final response = await http.get(
        Uri.parse(AppUrl.getIsclients),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> dataList = decoded['data']?['clients'] ?? [];

        print('Number of clients in response: ${dataList.length}');

        List<Client> clients = [];
        for (int i = 0; i < dataList.length; i++) {
          try {
            final client = Client.fromJson(dataList[i]);
            clients.add(client);
          } catch (e) {
            print('Error parsing client at index $i: $e');
            print('Problematic data: ${dataList[i]}');
            continue;
          }
        }

        return clients;
      } else {
        throw Exception(
          'Failed to load clients: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching clients: $e');
      throw Exception('Error fetching clients: $e');
    }
  }

  Future<List<Project>> fetchProjects() async {
    try {
      final headers = await this.headers;
      final response = await http.get(
        Uri.parse(AppUrl.getIsProjects),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> dataList = decoded['data'] ?? [];

        print('Number of projects in response: ${dataList.length}');

        List<Project> projects = [];
        for (int i = 0; i < dataList.length; i++) {
          try {
            final project = Project.fromJson(dataList[i]);
            projects.add(project);
          } catch (e) {
            print('Error parsing project at index $i: $e');
            print('Problematic data: ${dataList[i]}');
            continue;
          }
        }

        return projects;
      } else {
        throw Exception(
          'Failed to load projects: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching projects: $e');
      throw Exception('Error fetching projects: $e');
    }
  }

  Future<bool> createProject(Map<String, dynamic> projectData) async {
    try {
      final headers = await this.headers;
      final response = await http.post(
        Uri.parse(AppUrl.getIsProjects),
        headers: headers,
        body: jsonEncode(projectData),
      );

      print('Create project response status: ${response.statusCode}');
      print('Create project response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return true;
        } else {
          throw Exception('Failed to create project: ${decoded['message']}');
        }
      } else {
        throw Exception(
          'Failed to create project: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error creating project: $e');
      throw Exception('Error creating project: $e');
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      final headers = await this.headers;
      final response = await http.delete(
        Uri.parse(AppUrl.deleteIsProjects),
        headers: headers,
        body: jsonEncode({
          'ids': [projectId],
        }),
      );

      print('Delete project response status: ${response.statusCode}');
      print('Delete project response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return true;
        } else {
          throw Exception('Failed to delete project: ${decoded['message']}');
        }
      } else {
        throw Exception(
          'Failed to delete project: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error deleting project: $e');
      throw Exception('Error deleting project: $e');
    }
  }
}