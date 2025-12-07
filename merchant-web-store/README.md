# متجر الويب للتاجر - Cloudflare Pages

متجر ويب احترافي للتاجر مبني باستخدام Cloudflare Pages.

## المميزات

- ✅ تصميم احترافي وحديث
- ✅ عرض هوية المتجر (الاسم، الوصف، معلومات الاتصال)
- ✅ عرض المنتجات مع الفئات
- ✅ سلة تسوق
- ✅ متجاوب مع جميع الأجهزة
- ✅ ربط مع Worker API

## البنية

```
merchant-web-store/
├── public/
│   ├── index.html      # الصفحة الرئيسية
│   ├── styles.css      # التصميم
│   └── app.js          # JavaScript
├── package.json
├── wrangler.toml
└── README.md
```

## التطوير

```bash
# تثبيت التبعيات
npm install

# تشغيل محلي
npm run dev

# النشر
npm run deploy
```

## الإعداد

1. قم بتحديث `API_BASE_URL` في `app.js` إذا لزم الأمر
2. قم بتحديث `STORE_ID` أو استخدم query parameter: `?store_id=YOUR_STORE_ID`
3. قم بتحديث `wrangler.toml` مع معلومات Cloudflare Pages الخاصة بك

## الاستخدام

- افتح المتجر: `https://your-store.merchant.mbuy.com?store_id=STORE_ID`
- أو استخدم `STORE_ID` الافتراضي في الكود

## الملفات

- `index.html`: هيكل الصفحة
- `styles.css`: التصميم والأنماط
- `app.js`: منطق التطبيق وربط API

## API Endpoints المستخدمة

- `GET /public/stores/:id` - جلب معلومات المتجر
- `GET /public/categories?store_id=:id` - جلب فئات المتجر
- `GET /public/products?store_id=:id` - جلب منتجات المتجر

## ملاحظات

- جميع المفاتيح السرية في Worker Secrets
- المتجر يعمل كـ Static Site على Cloudflare Pages
- البيانات تأتي من Worker API

