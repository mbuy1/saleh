# 📱 MBUY Flutter Application

<div dir="rtl">

## 📋 نظرة عامة

تطبيق Flutter متكامل يجمع بين تجربة التسوق للعملاء وإدارة المتاجر للتجار في منصة واحدة.

---

## ✨ الميزات

### للعملاء 👥
- 🛍️ التسوق من متاجر متعددة
- 🛒 سلة تسوق ذكية
- 💰 محفظة إلكترونية
- 🎁 كوبونات خصم
- 📦 تتبع الطلبات
- ⭐ نظام النقاط

### للتجار 🏪
- 🏬 إنشاء وإدارة المتاجر
- 📦 إدارة المنتجات
- 📊 لوحة تحكم شاملة
- 💳 محفظة التاجر
- ⭐ نظام نقاط مع ميزات مدفوعة
- 🚀 دعم المتجر (Boost)

---

## 🚀 البدء السريع

### المتطلبات

```bash
flutter --version  # يجب أن يكون 3.10 أو أحدث
```

### التثبيت

```bash
# استنساخ المشروع
git clone <repository-url>
cd saleh

# تثبيت Dependencies
flutter pub get

# تشغيل التطبيق
flutter run
```

---

## 🔐 الإعداد

### Environment Variables

إنشاء ملف `.env` في `saleh/`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
WORKER_URL=https://your-worker.workers.dev
```

⚠️ **مهم:** لا تشارك ملف `.env` أو ترفعه إلى Git!

---

## 📂 هيكل المشروع

```
lib/
├── core/              # الوظائف الأساسية
│   ├── services/     # API Service, Auth Repository
│   ├── theme/        # نظام التصميم
│   └── root_widget.dart
│
├── features/          # الميزات حسب النطاق
│   ├── auth/         # المصادقة
│   ├── customer/     # ميزات العميل
│   └── merchant/     # ميزات التاجر
│
└── shared/           # Widgets مشتركة
```

---

## 🎨 التصميم

- 🎨 ألوان: جراديانت أزرق → موف
- ☀️ Light Theme أنيق ونظيف
- 🔤 دعم كامل للعربية (RTL)

---

## 🔄 التدفقات الرئيسية

### تسجيل الدخول

```
User Input → AuthRepository.login() → Worker API
→ Save token → Verify → Navigate to Home
```

### إضافة منتج

```
Merchant Input → ApiService.post('/secure/products')
→ Worker verifies JWT → Creates product → Updates UI
```

---

## 🧪 الاختبار

```bash
# تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test
```

---

## 📚 التوثيق

- [API Documentation](./MBUY_API_DOCUMENTATION.md)
- [Architecture](../docs/ARCHITECTURE.md)
- [Development Guide](../docs/DEVELOPMENT.md)

---

## 🐛 Troubleshooting

راجع [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) للمشاكل الشائعة.

---

## 🔗 Related Projects

- **Backend:** [mbuy-backend](../mbuy-backend/)
- **Worker:** [mbuy-worker](../mbuy-worker/)

---

</div>
