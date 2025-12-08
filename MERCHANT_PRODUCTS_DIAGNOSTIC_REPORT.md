---
# تقرير تشخيص ربط التاجر بالمنتجات في مشروع MBUY

## 1) فحص هيكلة الجداول في Supabase
ابحث في سكربتات SQL أو في الـ schema عن الجداول التالية (أو ما يشبهها بالأسماء):
- users أو auth.users
- user_profiles / profiles
- merchants أو stores أو merchant_stores
- products
- أي جدول علاقة بين التاجر والمنتجات (مثل: merchant_products أو store_id داخل products)

جدول يوضح الربط:
| الجدول         | المفتاح الأساسي | الحقل الرابط مع التالي |
|---------------|----------------|------------------------|
| auth.users    | id             | user_profiles.user_id  |
| user_profiles | id             | stores.owner_id        |
| stores        | id             | products.store_id      |
| products      | id             | -                      |

سلسلة الربط:
- المستخدم → profile: user_profiles.user_id = auth.users.id
- profile → متجر: stores.owner_id = user_profiles.id
- متجر → منتجات: products.store_id = stores.id

---

## 2) فحص وجود بيانات فعلية لهذا التاجر
اختر حساب التاجر المستخدم حاليًا (مثلاً عبر email أو id).

استعلامات SQL:
- هل يوجد له profile؟
```sql
SELECT * FROM user_profiles WHERE user_id = '<USER_ID>'; 
```
- هل يوجد له متجر؟
```sql
SELECT * FROM stores WHERE owner_id = '<PROFILE_ID>';
```
- كم منتج مرتبط بالمتجر؟
```sql
SELECT * FROM products WHERE store_id = '<STORE_ID>';
```

النتائج المطلوبة:
- عدد الصفوف في user_profiles لهذا المستخدم
- عدد المتاجر المرتبطة به
- عدد المنتجات المرتبطة بالمتجر

---

## 3) فحص منطق الـ API في Worker
ابحث عن endpoint مثل `/secure/merchant/products`.

الكود المطلوب:
- استخراج user_id من JWT
- ربط user_id بـ profile ثم store
- جلب المنتجات عبر store_id

تسلسل الربط:
user_id → profile → store_id → products

تحقق من:
- هل يعتمد على user_id الصحيح؟
- هل الفلترة تعتمد على store_id الموجود فعليًا؟
- هل هناك شرط يسبب NOT_FOUND إذا لم يوجد متجر أو منتج؟

ملخص الربط: المفتاح الأساسي هو user_id ثم owner_id ثم store_id.

---

## 4) فحص منطق Flutter عند جلب المنتجات
ابحث عن الكلاس أو الشاشة التي تجلب المنتجات.

تحليل الدالة:
- ما هو المسار (URL)؟
- هل ترسل storeId أو merchantId؟
- كيف تتعامل مع الرد؟

تحقق من تطابق الفلترة بين Flutter وWorker.

---

## 5) تشخيص سبب ظهور “لا توجد منتجات” مع خطأ NOT_FOUND
بعد فهم السلسلة:
- هل المشكلة في عدم وجود بيانات؟
- أم في الفلترة؟
- أم في الربط بين user_id والتاجر؟

استنتاج واضح حسب النتائج.

---

## 6) اقتراح خطة إصلاح (بدون تنفيذ)
خطة إصلاح مقترحة:
1. التأكد من ربط user_profiles بـ stores بشكل صحيح.
2. تعديل منطق Worker ليعتمد على السلسلة الصحيحة (user_id → profile → store → products).
3. التأكد من أن Flutter يستخدم endpoint الصحيح ويقرأ الرد بشكل متوافق مع الـ API.
4. إضافة اختبارات تحقق من وجود بيانات فعلية لكل سلسلة الربط.
5. توثيق الربط في قاعدة البيانات والكود.

---

لا تقم بأي تعديل في الكود أو قاعدة البيانات، أريد فحص + تقرير + خطة إصلاح فقط.
التقرير يكون منظم بعناوين فرعية وواضح حتى أستطيع أن أقرر بعدها ماذا أنفذ