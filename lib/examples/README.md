# 📝 Examples - MBUY

<div dir="rtl">

## نظرة عامة

هذا المجلد يحتوي على أمثلة توضيحية لاستخدام الميزات المختلفة في MBUY.

---

## الأمثلة المتاحة

### 1. استخدام API Service

```dart
import 'package:saleh/core/services/api_service.dart';

// GET request
final products = await ApiService.get('/secure/products');

// POST request
final response = await ApiService.post(
  '/secure/products',
  data: {
    'name': 'Product Name',
    'price': 100.0,
  },
);

// PUT request
final updated = await ApiService.put(
  '/secure/products/id',
  data: {
    'name': 'Updated Name',
  },
);

// DELETE request
await ApiService.delete('/secure/products/id');
```

### 2. Authentication

```dart
import 'package:saleh/features/auth/data/auth_repository.dart';

// Register
final registerResponse = await AuthRepository.register(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'User Name',
);

// Login
final loginResponse = await AuthRepository.login(
  email: 'user@example.com',
  password: 'password123',
);

// Get current user
final user = await AuthRepository.me();

// Logout
await AuthRepository.logout();
```

### 3. رفع الصور

```dart
import 'package:saleh/core/services/image_upload_service.dart';

// Upload image
final imageUrl = await ImageUploadService.uploadImage(
  file: File('path/to/image.jpg'),
  folder: 'products',
);

print('Image uploaded: $imageUrl');
```

---

## ملاحظات

- ✅ استخدم `ApiService` لجميع API calls
- ✅ لا تستخدم `supabaseClient` مباشرة
- ✅ جميع الطلبات المحمية تتطلب JWT token

---

</div>

