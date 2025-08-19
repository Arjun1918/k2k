import 'package:flutter/material.dart';
import 'package:k2k/Iron_smith/master_data/projects/model/is_project_model.dart';
import 'package:k2k/Iron_smith/master_data/projects/repo/is_projects.dart';

class IsProjectsProvider with ChangeNotifier {
  final ProjectsRepository _repository = ProjectsRepository();
  List<Project> _projects = [];
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _projects;
  List<Client> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProjects({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (refresh) {
      _projects = [];
    }
    notifyListeners();

    try {
      final newProjects = await _repository.fetchProjects();
      _projects = newProjects;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClients() async {
    if (_isLoading) return;

    _isLoading = true;
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

  Future<bool> createProject(Map<String, dynamic> projectData) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.createProject(projectData);

      if (success) {
        await fetchProjects(refresh: true);
        _error = null;
      }

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProject(String projectId) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.deleteProject(projectId);

      if (success) {
        _projects.removeWhere((p) => p.id == projectId);
        notifyListeners();

        await fetchProjects(refresh: true);
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