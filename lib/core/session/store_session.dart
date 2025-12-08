import 'package:flutter/foundation.dart';

class StoreSession extends ChangeNotifier {
  String? _storeId;

  String? get storeId => _storeId;
  bool get hasStore => _storeId != null && _storeId!.isNotEmpty;

  void setStoreId(String id) {
    _storeId = id;
    notifyListeners();
  }

  void clear() {
    _storeId = null;
    notifyListeners();
  }
}
