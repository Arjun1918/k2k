import 'package:flutter/material.dart';
import 'package:k2k/Iron_smith/master_data/clients/model/Is_clients.dart';
import 'package:k2k/Iron_smith/master_data/clients/repo/is_clients_repo.dart';

class IsClientsProvider with ChangeNotifier {
  final ClientsRepository _repository = ClientsRepository();
  List<Client> _clients = [];
  bool _isLoading = false;
  bool _isDeleting = false;
  String? _error;

  List<Client> get clients => _clients;
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  String? get error => _error;

  Future<void> fetchClients({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (refresh) {
      _clients = [];
    }
    notifyListeners();

    try {
      final newClients = await _repository.fetchClients();
      _clients = newClients;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addClient(Client client) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addClient(client);
      _error = null;
      await fetchClients(refresh: true);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClient(Client client) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateClient(client);
      _error = null;
      await fetchClients(refresh: true);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteClient(String clientId) async {
    if (_isLoading || _isDeleting) return false;

    _isDeleting = true;
    notifyListeners();

    try {
      final success = await _repository.deleteClient(clientId);
      if (success) {
        _clients.removeWhere((client) => client.id == clientId);
        _error = null;
      } else {
        _error = 'Failed to delete client';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}