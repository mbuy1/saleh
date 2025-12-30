'use client';

import { useState } from 'react';
import Link from 'next/link';

type Gateway = 'moyasar' | 'tap' | 'paytabs' | 'hyperpay';

const gateways: Record<Gateway, {
  name: string;
  nameAr: string;
  logo: string;
  website: string;
  signupUrl: string;
  description: string;
  fees: string;
  settlementTime: string;
  supportedMethods: string[];
  requirements: string[];
  steps: { title: string; description: string }[];
  apiKeyLabels: { key: string; secret: string; webhook?: string };
}> = {
  moyasar: {
    name: 'Moyasar',
    nameAr: 'مُيسر',
    logo: '💳',
    website: 'https://moyasar.com',
    signupUrl: 'https://moyasar.com/ar/signup',
    description: 'بوابة دفع سعودية موثوقة تدعم مدى وآبل باي وبطاقات الائتمان',
    fees: '2.5% + 1 ر.س لكل معاملة',
    settlementTime: '2-3 أيام عمل',
    supportedMethods: ['مدى', 'فيزا', 'ماستركارد', 'آبل باي', 'STC Pay'],
    requirements: [
      'سجل تجاري ساري المفعول',
      'حساب بنكي تجاري باسم المنشأة',
      'هوية المالك أو المفوض',
      'عنوان المنشأة',
    ],
    steps: [
      {
        title: 'إنشاء حساب',
        description: 'اذهب إلى moyasar.com واضغط على "إنشاء حساب" ثم أدخل بياناتك',
      },
      {
        title: 'رفع الوثائق',
        description: 'ارفع صورة السجل التجاري وشهادة الحساب البنكي',
      },
      {
        title: 'انتظار الموافقة',
        description: 'ستتم مراجعة طلبك خلال 1-3 أيام عمل',
      },
      {
        title: 'الحصول على المفاتيح',
        description: 'بعد الموافقة، اذهب إلى الإعدادات > API Keys',
      },
      {
        title: 'إدخال المفاتيح في MBUY',
        description: 'انسخ المفاتيح وأدخلها في إعدادات الدفع بمتجرك',
      },
    ],
    apiKeyLabels: {
      key: 'Publishable Key (pk_live_...)',
      secret: 'Secret Key (sk_live_...)',
    },
  },
  tap: {
    name: 'Tap Payments',
    nameAr: 'تاب',
    logo: '👆',
    website: 'https://tap.company',
    signupUrl: 'https://register.tap.company',
    description: 'بوابة دفع خليجية رائدة تدعم أكثر من 6 دول',
    fees: '2.65% لكل معاملة',
    settlementTime: '2 يوم عمل',
    supportedMethods: ['مدى', 'فيزا', 'ماستركارد', 'آبل باي', 'KNET', 'بنفت'],
    requirements: [
      'سجل تجاري أو رخصة عمل',
      'حساب بنكي تجاري',
      'هوية المالك',
      'إثبات عنوان',
    ],
    steps: [
      {
        title: 'التسجيل',
        description: 'اذهب إلى register.tap.company وأنشئ حساب جديد',
      },
      {
        title: 'اختيار الدولة',
        description: 'اختر المملكة العربية السعودية وأكمل البيانات',
      },
      {
        title: 'التحقق من الهوية',
        description: 'ارفع صورة الهوية والسجل التجاري',
      },
      {
        title: 'ربط الحساب البنكي',
        description: 'أدخل بيانات الحساب البنكي للتحويلات',
      },
      {
        title: 'الحصول على المفاتيح',
        description: 'من لوحة التحكم > goSell > API Keys',
      },
    ],
    apiKeyLabels: {
      key: 'Publishable Key',
      secret: 'Secret Key',
    },
  },
  paytabs: {
    name: 'PayTabs',
    nameAr: 'باي تابز',
    logo: '💰',
    website: 'https://paytabs.com',
    signupUrl: 'https://site.paytabs.com/signup',
    description: 'بوابة دفع سعودية تدعم سداد والتقسيط',
    fees: '2.5% - 2.9% لكل معاملة',
    settlementTime: '2-3 أيام عمل',
    supportedMethods: ['مدى', 'فيزا', 'ماستركارد', 'آبل باي', 'سداد', 'STC Pay'],
    requirements: [
      'سجل تجاري ساري',
      'حساب بنكي تجاري',
      'هوية المالك أو وكيل',
      'عقد إيجار أو ملكية',
    ],
    steps: [
      {
        title: 'إنشاء حساب',
        description: 'سجل في site.paytabs.com واختر السعودية',
      },
      {
        title: 'ملء استمارة KYC',
        description: 'أكمل بيانات الشركة والمالك',
      },
      {
        title: 'رفع المستندات',
        description: 'السجل التجاري + الهوية + شهادة الحساب البنكي',
      },
      {
        title: 'مراجعة الطلب',
        description: 'سيتواصل معك فريق PayTabs خلال 2-5 أيام',
      },
      {
        title: 'تفعيل الحساب',
        description: 'احصل على Profile ID و Server Key من الإعدادات',
      },
    ],
    apiKeyLabels: {
      key: 'Profile ID',
      secret: 'Server Key',
    },
  },
  hyperpay: {
    name: 'HyperPay',
    nameAr: 'هايبر باي',
    logo: '⚡',
    website: 'https://hyperpay.com',
    signupUrl: 'https://hyperpay.com/contact',
    description: 'بوابة دفع عالمية بتواجد قوي في السعودية',
    fees: 'حسب الاتفاق (تواصل معهم)',
    settlementTime: '1-2 يوم عمل',
    supportedMethods: ['مدى', 'فيزا', 'ماستركارد', 'آبل باي', 'سداد', 'تمارا'],
    requirements: [
      'سجل تجاري',
      'حساب بنكي تجاري',
      'هوية المفوض',
      'توقيع عقد مع HyperPay',
    ],
    steps: [
      {
        title: 'التواصل مع المبيعات',
        description: 'تواصل عبر hyperpay.com/contact أو 920033633',
      },
      {
        title: 'تقديم المتطلبات',
        description: 'أرسل السجل التجاري وبيانات الشركة',
      },
      {
        title: 'توقيع العقد',
        description: 'بعد الموافقة، وقّع عقد الخدمة',
      },
      {
        title: 'استلام البيانات',
        description: 'ستحصل على Entity ID و Access Token',
      },
      {
        title: 'التكامل',
        description: 'أدخل البيانات في إعدادات MBUY',
      },
    ],
    apiKeyLabels: {
      key: 'Entity ID',
      secret: 'Access Token',
    },
  },
};

export default function PaymentGatewaysDocsPage() {
  const [selectedGateway, setSelectedGateway] = useState<Gateway>('moyasar');
  const gateway = gateways[selectedGateway];

  return (
    <div className="min-h-screen bg-gray-50" dir="rtl">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-6xl mx-auto px-4 py-6">
          <Link href="/" className="text-primary-600 hover:underline mb-2 inline-block">
            ← العودة للرئيسية
          </Link>
          <h1 className="text-3xl font-bold text-gray-900">
            دليل إعداد بوابات الدفع
          </h1>
          <p className="text-gray-600 mt-2">
            اختر بوابة الدفع المناسبة لمتجرك واتبع الخطوات للتفعيل
          </p>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-4 py-8">
        {/* Gateway Selector */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          {(Object.keys(gateways) as Gateway[]).map((key) => (
            <button
              key={key}
              onClick={() => setSelectedGateway(key)}
              className={`p-4 rounded-xl border-2 transition-all ${
                selectedGateway === key
                  ? 'border-primary-500 bg-primary-50 shadow-md'
                  : 'border-gray-200 bg-white hover:border-gray-300'
              }`}
            >
              <div className="text-3xl mb-2">{gateways[key].logo}</div>
              <div className="font-bold">{gateways[key].nameAr}</div>
              <div className="text-sm text-gray-500">{gateways[key].name}</div>
            </button>
          ))}
        </div>

        {/* Gateway Details */}
        <div className="bg-white rounded-2xl shadow-lg overflow-hidden">
          {/* Gateway Header */}
          <div className="bg-gradient-to-l from-primary-600 to-primary-700 text-white p-6">
            <div className="flex items-center gap-4">
              <div className="text-5xl">{gateway.logo}</div>
              <div>
                <h2 className="text-2xl font-bold">{gateway.nameAr}</h2>
                <p className="opacity-90">{gateway.description}</p>
              </div>
            </div>
          </div>

          {/* Quick Info */}
          <div className="grid md:grid-cols-3 gap-4 p-6 bg-gray-50 border-b">
            <div className="text-center p-4 bg-white rounded-lg">
              <div className="text-sm text-gray-500">الرسوم</div>
              <div className="font-bold text-lg">{gateway.fees}</div>
            </div>
            <div className="text-center p-4 bg-white rounded-lg">
              <div className="text-sm text-gray-500">مدة التحويل</div>
              <div className="font-bold text-lg">{gateway.settlementTime}</div>
            </div>
            <div className="text-center p-4 bg-white rounded-lg">
              <div className="text-sm text-gray-500">طرق الدفع</div>
              <div className="font-bold text-lg">{gateway.supportedMethods.length} طريقة</div>
            </div>
          </div>

          <div className="p-6 space-y-8">
            {/* Supported Methods */}
            <section>
              <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
                <span className="w-8 h-8 bg-green-100 text-green-600 rounded-full flex items-center justify-center">✓</span>
                طرق الدفع المدعومة
              </h3>
              <div className="flex flex-wrap gap-2">
                {gateway.supportedMethods.map((method) => (
                  <span
                    key={method}
                    className="px-4 py-2 bg-green-50 text-green-700 rounded-full text-sm font-medium"
                  >
                    {method}
                  </span>
                ))}
              </div>
            </section>

            {/* Requirements */}
            <section>
              <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
                <span className="w-8 h-8 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center">📋</span>
                المتطلبات
              </h3>
              <ul className="space-y-2">
                {gateway.requirements.map((req, i) => (
                  <li key={i} className="flex items-start gap-3">
                    <span className="w-6 h-6 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center text-sm flex-shrink-0 mt-0.5">
                      {i + 1}
                    </span>
                    <span>{req}</span>
                  </li>
                ))}
              </ul>
            </section>

            {/* Steps */}
            <section>
              <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
                <span className="w-8 h-8 bg-purple-100 text-purple-600 rounded-full flex items-center justify-center">🚀</span>
                خطوات التفعيل
              </h3>
              <div className="space-y-4">
                {gateway.steps.map((step, i) => (
                  <div key={i} className="flex gap-4">
                    <div className="flex flex-col items-center">
                      <div className="w-10 h-10 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                        {i + 1}
                      </div>
                      {i < gateway.steps.length - 1 && (
                        <div className="w-0.5 h-full bg-primary-200 my-2" />
                      )}
                    </div>
                    <div className="pb-6">
                      <h4 className="font-bold text-gray-900">{step.title}</h4>
                      <p className="text-gray-600">{step.description}</p>
                    </div>
                  </div>
                ))}
              </div>
            </section>

            {/* API Keys Guide */}
            <section className="bg-yellow-50 rounded-xl p-6 border border-yellow-200">
              <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
                <span className="w-8 h-8 bg-yellow-200 text-yellow-700 rounded-full flex items-center justify-center">🔑</span>
                المفاتيح المطلوبة في MBUY
              </h3>
              <div className="space-y-3">
                <div className="flex items-center gap-3 bg-white p-3 rounded-lg">
                  <span className="font-mono text-sm bg-gray-100 px-2 py-1 rounded">
                    {gateway.apiKeyLabels.key}
                  </span>
                  <span className="text-gray-600">← أدخله في حقل "المفتاح العام"</span>
                </div>
                <div className="flex items-center gap-3 bg-white p-3 rounded-lg">
                  <span className="font-mono text-sm bg-gray-100 px-2 py-1 rounded">
                    {gateway.apiKeyLabels.secret}
                  </span>
                  <span className="text-gray-600">← أدخله في حقل "المفتاح السري"</span>
                </div>
              </div>
              <p className="text-yellow-700 text-sm mt-4">
                ⚠️ احفظ المفاتيح بأمان ولا تشاركها مع أي شخص
              </p>
            </section>

            {/* CTA */}
            <div className="flex flex-col sm:flex-row gap-4">
              <a
                href={gateway.signupUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 bg-primary-600 text-white text-center py-4 px-6 rounded-xl font-bold hover:bg-primary-700 transition-colors"
              >
                التسجيل في {gateway.nameAr} ←
              </a>
              <a
                href={gateway.website}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 bg-gray-100 text-gray-700 text-center py-4 px-6 rounded-xl font-bold hover:bg-gray-200 transition-colors"
              >
                زيارة الموقع
              </a>
            </div>
          </div>
        </div>

        {/* FAQ Section */}
        <div className="mt-8 bg-white rounded-2xl shadow-lg p-6">
          <h2 className="text-xl font-bold mb-6">الأسئلة الشائعة</h2>
          
          <div className="space-y-4">
            <details className="border rounded-lg">
              <summary className="p-4 cursor-pointer font-medium hover:bg-gray-50">
                أي بوابة أختار؟
              </summary>
              <div className="p-4 pt-0 text-gray-600">
                <ul className="list-disc mr-4 space-y-1">
                  <li><strong>مُيسر:</strong> الأسهل في التسجيل والأفضل للمبتدئين</li>
                  <li><strong>تاب:</strong> الأفضل إذا كان لديك عملاء من دول الخليج</li>
                  <li><strong>باي تابز:</strong> الأفضل إذا تريد دعم سداد</li>
                  <li><strong>هايبر باي:</strong> الأفضل للمتاجر الكبيرة</li>
                </ul>
              </div>
            </details>

            <details className="border rounded-lg">
              <summary className="p-4 cursor-pointer font-medium hover:bg-gray-50">
                كم تستغرق الموافقة؟
              </summary>
              <div className="p-4 pt-0 text-gray-600">
                عادة من 1-5 أيام عمل حسب اكتمال المستندات وسرعة البوابة
              </div>
            </details>

            <details className="border rounded-lg">
              <summary className="p-4 cursor-pointer font-medium hover:bg-gray-50">
                هل يمكنني استخدام أكثر من بوابة؟
              </summary>
              <div className="p-4 pt-0 text-gray-600">
                نعم! يمكنك إضافة جميع البوابات واختيار واحدة كافتراضية. العملاء سيدفعون عبر البوابة الافتراضية.
              </div>
            </details>

            <details className="border rounded-lg">
              <summary className="p-4 cursor-pointer font-medium hover:bg-gray-50">
                أين يذهب المال؟
              </summary>
              <div className="p-4 pt-0 text-gray-600">
                المال يذهب مباشرة لحسابك البنكي المربوط بالبوابة. MBUY لا يحتفظ بأي أموال - نحن وسيط تقني فقط.
              </div>
            </details>

            <details className="border rounded-lg">
              <summary className="p-4 cursor-pointer font-medium hover:bg-gray-50">
                ماذا عن الرسوم؟
              </summary>
              <div className="p-4 pt-0 text-gray-600">
                رسوم البوابة تُخصم تلقائياً من كل معاملة. مثلاً: إذا دفع العميل 100 ر.س ورسوم البوابة 2.5%، ستحصل على 97.5 ر.س.
              </div>
            </details>
          </div>
        </div>

        {/* Support */}
        <div className="mt-8 text-center text-gray-500">
          <p>تحتاج مساعدة؟ تواصل معنا عبر الدعم الفني</p>
        </div>
      </main>
    </div>
  );
}
