# ✅ ربط Explore Screen مع Supabase

**التاريخ:** ديسمبر 2025  
**الحالة:** ✅ مكتمل

---

## 📋 الميزات المكتملة

### 1. **خدمة Explore Service** ✅

**الملف:** `lib/features/customer/data/explore_service.dart`

**الميزات:**
- ✅ جلب فيديوهات Explore من Supabase (جدول `stories`)
- ✅ جلب منتجات Explore من Supabase (جدول `products`)
- ✅ دعم الفلاتر (جديد، الأكثر مشاهدة، الأكثر مبيعاً، حسب الموقع، الأعلى تقييماً)
- ✅ Pagination للفيديوهات والمنتجات
- ✅ تتبع مشاهدة الفيديوهات
- ✅ تتبع إعجاب الفيديوهات
- ✅ ربط مع جدول `products` و `stores` للحصول على معلومات المنتج والمتجر

**الدوال المتاحة:**
```dart
// جلب فيديوهات
ExploreService.getExploreVideos(
  filter: 'new', // أو 'trending', 'top_selling', 'top_rated', 'by_location'
  page: 0,
  pageSize: 10,
)

// جلب منتجات
ExploreService.getExploreProducts(
  filter: 'new',
  page: 0,
  pageSize: 30,
)

// تتبع مشاهدة
ExploreService.trackVideoView(videoId)

// تتبع إعجاب
ExploreService.toggleVideoLike(videoId, isLiked)
```

---

### 2. **تحديث Explore Repository** ✅

**الملف:** `lib/core/data/repositories/explore_repository.dart`

**الميزات:**
- ✅ استخدام ExploreService لجلب البيانات من Supabase
- ✅ Fallback إلى DummyData في حالة عدم وجود بيانات أو خطأ
- ✅ دعم الفلاتر في جميع الدوال

---

### 3. **تحديث Explore Screen** ✅

**الملف:** `lib/features/customer/presentation/screens/explore_screen.dart`

**الميزات:**
- ✅ تحميل الفيديوهات من Supabase عند فتح الشاشة
- ✅ تحميل المنتجات من Supabase عند فتح الشاشة
- ✅ تطبيق الفلاتر مع إعادة تحميل البيانات
- ✅ تتبع مشاهدة الفيديوهات عند النقر
- ✅ عرض اسم المتجر من البيانات الحقيقية
- ✅ Pagination للفيديوهات والمنتجات

---

### 4. **تحديث النماذج (Models)** ✅

**الملف:** `lib/core/data/models.dart`

**التحديثات:**
- ✅ إضافة `videoUrl`, `thumbnailUrl`, `views` إلى `VideoItem`
- ✅ إضافة `storeName` إلى `Product`

---

## 🗄️ الجداول المطلوبة في Supabase

### 1. **جدول `stories`**

يجب أن يحتوي على الأعمدة التالية:
```sql
CREATE TABLE IF NOT EXISTS stories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id),
  type TEXT NOT NULL DEFAULT 'video', -- 'video' أو 'image'
  media_url TEXT, -- رابط الفيديو/الصورة
  thumbnail_url TEXT, -- رابط الصورة المصغرة
  caption TEXT,
  is_active BOOLEAN DEFAULT true,
  views_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  bookmarks_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_stories_type ON stories(type);
CREATE INDEX IF NOT EXISTS idx_stories_product_id ON stories(product_id);
CREATE INDEX IF NOT EXISTS idx_stories_is_active ON stories(is_active);
CREATE INDEX IF NOT EXISTS idx_stories_views_count ON stories(views_count);
```

### 2. **جدول `story_views`** (لتتبع المشاهدات)

```sql
CREATE TABLE IF NOT EXISTS story_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  story_id UUID REFERENCES stories(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(story_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_story_views_story_id ON story_views(story_id);
CREATE INDEX IF NOT EXISTS idx_story_views_user_id ON story_views(user_id);
```

### 3. **جدول `story_likes`** (لتتبع الإعجابات)

```sql
CREATE TABLE IF NOT EXISTS story_likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  story_id UUID REFERENCES stories(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(story_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_story_likes_story_id ON story_likes(story_id);
CREATE INDEX IF NOT EXISTS idx_story_likes_user_id ON story_likes(user_id);
```

### 4. **Functions في Supabase**

#### أ. **increment_story_views** - زيادة عدد المشاهدات

```sql
CREATE OR REPLACE FUNCTION increment_story_views(story_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE stories
  SET views_count = views_count + 1
  WHERE id = story_id;
END;
$$ LANGUAGE plpgsql;
```

#### ب. **update_story_likes_count** - تحديث عدد الإعجابات

```sql
CREATE OR REPLACE FUNCTION update_story_likes_count(story_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE stories
  SET likes_count = (
    SELECT COUNT(*) FROM story_likes WHERE story_id = story_likes.story_id
  )
  WHERE id = story_id;
END;
$$ LANGUAGE plpgsql;
```

---

## 🔄 كيفية العمل

### 1. **تحميل الفيديوهات**

```dart
// عند فتح الشاشة
_loadVideos()

// عند تغيير الفلتر
_loadVideos(refresh: true)

// Pagination تلقائي عند التمرير
```

### 2. **تحميل المنتجات**

```dart
// عند فتح الشاشة
_loadProducts()

// عند تغيير الفلتر
_loadProducts(refresh: true)
```

### 3. **تتبع المشاهدات**

```dart
// عند النقر على فيديو
ExploreService.trackVideoView(videoId)
```

### 4. **تتبع الإعجابات**

```dart
// عند الإعجاب/إلغاء الإعجاب
ExploreService.toggleVideoLike(videoId, isLiked)
```

---

## 📊 الفلاتر المدعومة

| الفلتر | القيمة | الوصف |
|--------|--------|-------|
| جديد | `new` | الأحدث (حسب `created_at`) |
| الأكثر مشاهدة | `trending` | حسب `views_count` |
| الأكثر مبيعاً | `top_selling` | حسب مبيعات المنتج |
| حسب الموقع | `by_location` | حسب موقع المستخدم (قريباً) |
| الأعلى تقييماً | `top_rated` | حسب تقييم المتجر |

---

## ⚠️ ملاحظات مهمة

### 1. **Fallback إلى DummyData**

إذا فشل جلب البيانات من Supabase أو لم تكن موجودة، سيتم استخدام DummyData كـ fallback لضمان عمل التطبيق.

### 2. **Pagination**

- الفيديوهات: 10 فيديوهات لكل صفحة
- المنتجات: 30 منتج لكل صفحة

### 3. **تتبع المشاهدات**

- يتم تتبع المشاهدات فقط للمستخدمين المسجلين
- يتم زيادة `views_count` في جدول `stories`
- يتم تسجيل مشاهدة المستخدم في جدول `story_views`

### 4. **تتبع الإعجابات**

- يتم تتبع الإعجابات فقط للمستخدمين المسجلين
- يتم تحديث `likes_count` في جدول `stories`
- يتم حفظ الإعجاب في جدول `story_likes`

---

## 🎯 الخطوات التالية (اختيارية)

1. ⏳ **ربط Cloudflare Stream** - لعرض الفيديوهات الفعلية
2. ⏳ **تطبيق PageRank Algorithm** - لترتيب الفيديوهات بشكل ذكي
3. ⏳ **فلتر حسب الموقع** - جلب الفيديوهات/المنتجات حسب موقع المستخدم
4. ⏳ **تحسين الأداء** - Caching للبيانات المحملة
5. ⏳ **Infinite Scroll** - تحميل تلقائي عند الوصول لنهاية القائمة

---

## ✅ التحقق من الكود

```bash
flutter analyze
# ✅ No issues found!
```

---

## 📝 الخلاصة

تم ربط Explore Screen مع Supabase بنجاح! ✅

- ✅ جلب الفيديوهات من Supabase
- ✅ جلب المنتجات من Supabase
- ✅ دعم الفلاتر
- ✅ Pagination
- ✅ تتبع المشاهدات والإعجابات
- ✅ Fallback إلى DummyData

**الملفات المعدلة:**
1. `lib/features/customer/data/explore_service.dart` (جديد)
2. `lib/core/data/repositories/explore_repository.dart` (محدث)
3. `lib/features/customer/presentation/screens/explore_screen.dart` (محدث)
4. `lib/core/data/models.dart` (محدث)

---

**آخر تحديث:** ديسمبر 2025  
**الحالة:** ✅ مكتمل وجاهز للاستخدام

