import 'dart:async';
import 'package:flutter/material.dart';

/// Helper class لجعل GoRouter يستمع لتغييرات StateNotifier
/// يتم استخدامه في جميع Routers لتحديث التنقل عند تغيير حالة المصادقة
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

