
import 'package:flutter/material.dart';
import 'package:looninary/core/models/user_stats_model.dart';
import 'package:looninary/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsController with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  UserStats? _stats;
  bool _isLoading = true;

  UserStats? get stats => _stats;
  bool get isLoading => _isLoading;

  StatsController() {
    fetchStats();
  }

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle(); // Use maybeSingle to handle cases where a user has no stats yet

      if (response != null) {
        _stats = UserStats.fromJson(response);
      } else {
        // If no stats exist for the user, create an empty state
        _stats = UserStats.empty(userId);
      }
    } catch (e, stackTrace) {
      logger.e("Failed to fetch user stats", error: e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
