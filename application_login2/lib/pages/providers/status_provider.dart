import 'package:flutter/material.dart';
import '../UserStatus/status.dart';
import '../services/status_service.dart';

class StatusProvider extends ChangeNotifier {
  List<Status> _statuses = [];
  bool _isLoading = false;

  List<Status> get statuses => _statuses;
  bool get isLoading => _isLoading;

  Future<void> loadStatuses(int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await StatusService.getStatuses(userId);
    if (result['success']) {
      _statuses = result['statuses'];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createStatus(int userId, String name, String color) async {
    final result = await StatusService.createStatus(userId, name, color);
    
    if (result['success']) {
      _statuses.insert(0, result['status']);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteStatus(int id, int userId) async {
    final result = await StatusService.deleteStatus(id, userId);
    
    if (result['success']) {
      _statuses.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}