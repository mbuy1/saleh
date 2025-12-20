import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/features/products/presentation/screens/add_product/models/product_form_state.dart';

void main() {
  group('ProductFormState Tests', () {
    group('Constructor', () {
      test('القيم الافتراضية صحيحة', () {
        const state = ProductFormState();

        expect(state.name, isEmpty);
        expect(state.description, isEmpty);
        expect(state.price, isNull);
        expect(state.productType, equals(ProductType.physical));
        expect(state.showInStore, isTrue);
        expect(state.showInMbuyApp, isTrue);
        expect(state.showInDropshipping, isFalse);
        expect(state.hasUnsavedChanges, isFalse);
        expect(state.isSubmitting, isFalse);
      });

      test('يقبل قيم مخصصة', () {
        const state = ProductFormState(
          name: 'منتج تجريبي',
          price: 99.99,
          productType: ProductType.digital,
        );

        expect(state.name, equals('منتج تجريبي'));
        expect(state.price, equals(99.99));
        expect(state.productType, equals(ProductType.digital));
      });
    });

    group('copyWith', () {
      test('يحدث القيم المحددة فقط', () {
        const state = ProductFormState(
          name: 'المنتج الأصلي',
          price: 50.0,
          stock: 10,
        );

        final newState = state.copyWith(name: 'المنتج المحدث');

        expect(newState.name, equals('المنتج المحدث'));
        expect(newState.price, equals(50.0));
        expect(newState.stock, equals(10));
      });

      test('يمكن تحديث عدة قيم معاً', () {
        const state = ProductFormState();

        final newState = state.copyWith(
          name: 'منتج جديد',
          price: 100.0,
          stock: 50,
          hasUnsavedChanges: true,
        );

        expect(newState.name, equals('منتج جديد'));
        expect(newState.price, equals(100.0));
        expect(newState.stock, equals(50));
        expect(newState.hasUnsavedChanges, isTrue);
      });
    });

    group('currentTypeInfo', () {
      test('يرجع معلومات صحيحة للمنتج المادي', () {
        const state = ProductFormState(productType: ProductType.physical);

        expect(state.currentTypeInfo.type, equals(ProductType.physical));
        expect(state.currentTypeInfo.hasStock, isTrue);
        expect(state.currentTypeInfo.hasWeight, isTrue);
        expect(state.currentTypeInfo.hasDelivery, isTrue);
      });

      test('يرجع معلومات صحيحة للمنتج الرقمي', () {
        const state = ProductFormState(productType: ProductType.digital);

        expect(state.currentTypeInfo.type, equals(ProductType.digital));
        expect(state.currentTypeInfo.hasStock, isFalse);
        expect(state.currentTypeInfo.hasDigitalFile, isTrue);
        expect(state.currentTypeInfo.hasDelivery, isFalse);
      });

      test('يرجع معلومات صحيحة للخدمة', () {
        const state = ProductFormState(productType: ProductType.service);

        expect(state.currentTypeInfo.type, equals(ProductType.service));
        expect(state.currentTypeInfo.hasPrepTime, isTrue);
        expect(state.currentTypeInfo.hasStock, isFalse);
      });
    });

    group('completionPercentage', () {
      test('يرجع 0 للنموذج الفارغ', () {
        const state = ProductFormState();
        expect(state.completionPercentage, equals(0.0));
      });

      test('يزداد مع إضافة البيانات', () {
        const state1 = ProductFormState(name: 'منتج');
        const state2 = ProductFormState(name: 'منتج', price: 100);

        expect(state1.completionPercentage, greaterThan(0));
        expect(
          state2.completionPercentage,
          greaterThan(state1.completionPercentage),
        );
      });
    });

    group('profitMargin', () {
      test('يرجع null إذا لم يكن هناك سعر تكلفة', () {
        const state = ProductFormState(price: 100);
        expect(state.profitMargin, isNull);
      });

      test('يرجع null إذا كان سعر التكلفة صفر', () {
        const state = ProductFormState(price: 100, costPrice: 0);
        expect(state.profitMargin, isNull);
      });

      test('يحسب هامش الربح بشكل صحيح', () {
        const state = ProductFormState(price: 150, costPrice: 100);
        expect(state.profitMargin, equals(50.0));
      });

      test('يتعامل مع هامش ربح سلبي', () {
        const state = ProductFormState(price: 80, costPrice: 100);
        expect(state.profitMargin, equals(-20.0));
      });
    });

    group('profitAmount', () {
      test('يرجع null إذا لم يكن هناك أسعار', () {
        const state = ProductFormState();
        expect(state.profitAmount, isNull);
      });

      test('يحسب قيمة الربح بشكل صحيح', () {
        const state = ProductFormState(price: 150, costPrice: 100);
        expect(state.profitAmount, equals(50.0));
      });
    });

    group('discountPercentage', () {
      test('يرجع null إذا لم يكن هناك سعر أصلي', () {
        const state = ProductFormState(price: 100);
        expect(state.discountPercentage, isNull);
      });

      test('يرجع null إذا كان السعر الأصلي أقل من الحالي', () {
        const state = ProductFormState(price: 100, originalPrice: 80);
        expect(state.discountPercentage, isNull);
      });

      test('يحسب نسبة الخصم بشكل صحيح', () {
        const state = ProductFormState(price: 80, originalPrice: 100);
        expect(state.discountPercentage, equals(20.0));
      });
    });
  });

  group('ProductType Tests', () {
    test('يوجد 7 أنواع من المنتجات', () {
      expect(ProductType.values.length, equals(7));
    });

    test('كل نوع لديه معلومات مرتبطة', () {
      for (final type in ProductType.values) {
        expect(productTypes.containsKey(type), isTrue);
        expect(productTypes[type]!.name, isNotEmpty);
        expect(productTypes[type]!.description, isNotEmpty);
      }
    });
  });

  group('ProductTypeInfo Tests', () {
    test('المنتج المادي لديه الخصائص الصحيحة', () {
      final info = productTypes[ProductType.physical]!;
      expect(info.hasStock, isTrue);
      expect(info.hasWeight, isTrue);
      expect(info.hasDelivery, isTrue);
      expect(info.hasVariants, isTrue);
      expect(info.hasDigitalFile, isFalse);
    });

    test('الاشتراك لديه الخصائص الصحيحة', () {
      final info = productTypes[ProductType.subscription]!;
      expect(info.hasStock, isFalse);
      expect(info.hasWeight, isFalse);
      expect(info.hasDelivery, isFalse);
    });
  });
}
