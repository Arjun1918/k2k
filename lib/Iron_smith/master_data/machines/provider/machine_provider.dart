import 'package:flutter/material.dart';
import 'package:k2k/Iron_smith/master_data/machines/model/machines.dart';
import 'package:k2k/Iron_smith/master_data/machines/repo/machine_repo.dart';

class IsMachinesProvider with ChangeNotifier {
  final MachinesRepository _repository = MachinesRepository();
  List<Machines> _machines = [];
  bool _isLoading = false;
  String? _error;

  List<Machines> get machines => _machines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMachines({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (refresh) {
      _machines = []; // Clear the list for a full refresh
    }
    notifyListeners();

    try {
      final newMachines = await _repository.fetchMachines();
      _machines = newMachines; // Replace the list
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMachine(Machines machine) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addMachine(machine);
      _error = null;
      await fetchMachines(refresh: true); // Refresh the list
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMachine(Machines machine) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateMachine(machine);
      _error = null;
      await fetchMachines(refresh: true); // Refresh the list
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteMachine(String machineId) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.deleteMachine(machineId);

      if (success) {
        // ✅ Immediately remove from local list
        _machines.removeWhere((m) => m.id?.oid == machineId);
        notifyListeners();

        // Optional: still fetch to sync with server
        await fetchMachines(refresh: true);
      }

      _error = null;
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
