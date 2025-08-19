import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k2k/Iron_smith/master_data/clients/model/Is_clients.dart';
import 'package:k2k/api_services/api_services.dart';
import 'package:k2k/api_services/shared_preference/shared_preference.dart';

class ClientsRepository {
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

  Future<void> addClient(Client client) async {
    try {
      final headers = await this.headers;
      final response = await http.post(
        Uri.parse(AppUrl.getIsclients),
        headers: headers,
        body: jsonEncode({'name': client.name, 'address': client.address}),
      );

      print('Add client response status: ${response.statusCode}');
      print('Add client response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded['success'] != true) {
          throw Exception('Failed to add client: ${decoded['message']}');
        }
      } else {
        throw Exception(
          'Failed to add client: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error adding client: $e');
      throw Exception('Error adding client: $e');
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      final headers = await this.headers;
      final clientId = client.id;
      if (clientId == null) {
        throw Exception('Client ID is missing');
      }
      final response = await http.put(
        Uri.parse('${AppUrl.getIsclients}/$clientId'),
        headers: headers,
        body: jsonEncode({'name': client.name, 'address': client.address}),
      );

      print('Update client response status: ${response.statusCode}');
      print('Update client response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded['success'] != true) {
          throw Exception('Failed to update client: ${decoded['message']}');
        }
      } else {
        throw Exception(
          'Failed to update client: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error updating client: $e');
      throw Exception('Error updating client: $e');
    }
  }

  Future<bool> deleteClient(String clientId) async {
    try {
      final headers = await this.headers;
      final response = await http.delete(
        Uri.parse(AppUrl.deleteIsclients),
        headers: headers,
        body: jsonEncode({
          'ids': [clientId],
        }),
      );

      print('Delete client response status: ${response.statusCode}');
      print('Delete client response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return true;
        } else {
          throw Exception('Failed to delete client: ${decoded['message']}');
        }
      } else {
        throw Exception(
          'Failed to delete client: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error deleting client: $e');
      throw Exception('Error deleting client: $e');
    }
  }
}
