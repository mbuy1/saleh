import 'package:flutter/foundation.dart';
import '../../features/customer/data/models/saved_card_model.dart';

/// خدمة البطاقات المحفوظة (Saved Cards)
/// TODO: إكمال التنفيذ عند الحاجة
class SavedCardsService {
  /// جلب جميع البطاقات المحفوظة
  static Future<List<SavedCardModel>> getSavedCards() async {
    // TODO: تنفيذ API call
    debugPrint('TODO: Implement getSavedCards');
    return [];
  }

  /// حفظ بطاقة جديدة
  static Future<SavedCardModel> saveCard({
    required String cardToken,
    required String cardType,
    required String lastFourDigits,
    required String cardholderName,
    required DateTime expiryDate,
    bool isDefault = false,
  }) async {
    // TODO: تنفيذ API call
    throw UnimplementedError('TODO: Implement saveCard');
  }

  /// حذف بطاقة محفوظة
  static Future<void> deleteCard(String cardId) async {
    // TODO: تنفيذ API call
    throw UnimplementedError('TODO: Implement deleteCard');
  }

  /// تعيين بطاقة كافتراضية
  static Future<void> setDefaultCard(String cardId) async {
    // TODO: تنفيذ API call
    throw UnimplementedError('TODO: Implement setDefaultCard');
  }
}

