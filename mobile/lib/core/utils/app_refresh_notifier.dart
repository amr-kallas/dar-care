import 'package:flutter/foundation.dart';

/// Simple global refresh bus based on version counters per topic.
class AppRefreshNotifier extends ChangeNotifier {
  int _chatsVersion = 0;
  int _ordersVersion = 0;
  int _providerHomeVersion = 0;

  int get chatsVersion => _chatsVersion;
  int get ordersVersion => _ordersVersion;
  int get providerHomeVersion => _providerHomeVersion;

  void markChatsStale() {
    _chatsVersion++;
    notifyListeners();
  }

  void markOrdersStale() {
    _ordersVersion++;
    notifyListeners();
  }

  void markProviderHomeStale() {
    _providerHomeVersion++;
    notifyListeners();
  }

  void markAllForOrderUpdate() {
    _ordersVersion++;
    _providerHomeVersion++;
    _chatsVersion++;
    notifyListeners();
  }
}

final AppRefreshNotifier appRefreshNotifier = AppRefreshNotifier();
