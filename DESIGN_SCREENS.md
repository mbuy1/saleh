# mBuy App Screens - UI/UX Specification
## Meta AI Style × mBuy Purple Identity

---

## 📱 Screen 1: Home Screen (الرئيسية)

### Visual Hierarchy
```
┌─────────────────────────────────────┐
│  [Title: الرئيسية] 20px SemiBold   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔍 ابحث عن منتج...         │   │  Search Bar (Pill)
│  └─────────────────────────────┘   │
│                                     │
│  [الكل] [الأكثر مبيعاً] [عروض]    │  Filter Chips
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │  📷      │  │  📷      │       │
│  │          │  │          │       │
│  │ Product  │  │ Product  │       │  Product Grid
│  │ Name     │  │ Name     │       │  (2 columns)
│  │ ★★★★★    │  │ ★★★★★    │       │
│  │ 199 ر.س  │  │ 299 ر.س  │       │
│  └──────────┘  └──────────┘       │
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │  📷      │  │  📷      │       │
│  │          │  │          │       │
│  └──────────┘  └──────────┘       │
│                                     │
└─────────────────────────────────────┘
      Bottom Bar (Dark Transparent)
```

### Detailed Specs

**Header Section**
- Top Padding: 16px
- Title: "الرئيسية"
  - Font: Cairo SemiBold 20px
  - Color: #1A1A1A
  - Alignment: Right

**Search Bar**
- Margin Top: 12px
- Height: 44px
- Border Radius: 22px (Pill)
- Background: #F7F7F9
- Padding: 0 48px 0 16px
- Icon: 26px magnifier, right side, #6A6A6A
- Placeholder: Cairo Regular 14px, #9A9A9A
- No border
- Margin Bottom: 16px

**Filter Chips**
- Height: 32px
- Border Radius: 16px
- Padding: 0 16px
- Gap: 8px
- Font: Cairo Medium 13px
- Unselected:
  - Background: #FFFFFF
  - Border: 1px #E6E6E8
  - Text: #6A6A6A
- Selected:
  - Background: #7B2CF5
  - Border: none
  - Text: #FFFFFF
- Margin Bottom: 20px

**Product Grid**
- Padding: 16px
- Columns: 2
- Column Gap: 12px
- Row Gap: 16px
- Aspect Ratio: 0.75 (3:4)

**Product Card**
- Background: #FFFFFF
- Border Radius: 16px
- Padding: 12px
- Shadow: 0 1px 4px rgba(0, 0, 0, 0.06)

Product Card Content:
- Image Container:
  - Aspect Ratio: 1:1
  - Border Radius: 12px
  - Background: #F7F7F9
  - Margin Bottom: 10px
  
- Product Name:
  - Font: Cairo Medium 14px
  - Color: #1A1A1A
  - Max Lines: 2
  - Line Height: 20px
  - Margin Bottom: 6px
  
- Rating Row:
  - Stars: 14px yellow
  - Count: Cairo Regular 11px, #9A9A9A
  - Margin Bottom: 8px
  
- Price:
  - Font: Cairo Bold 16px
  - Color: #7B2CF5
  - Has "ر.س" suffix in Regular 13px

**Bottom Navigation Bar**
- Height: 64px
- Background: rgba(0, 0, 0, 0.7) with blur
- Icons: 26px
- Selected Icon: Purple gradient shader
- Unselected: White alpha 0.6
- No labels

---

## 📱 Screen 2: Explore (اكتشف - Reels)

### Visual Layout
```
┌─────────────────────────────────────┐
│ [≡]                      [@]        │  Top Bar
│                                     │
│                                     │
│        FULL SCREEN VIDEO            │
│              FEED                   │
│                                     │
│                          [❤️]  12K  │  Actions
│                          [💬]  340  │  (Right)
│                          [➤]  89   │
│                          [🔖]  450  │
│                                     │
│ [@Avatar] Store Name [+ متابعة]    │
│ Caption text here...                │  Bottom
│ ♪ Music Name • Artist    [🎵]      │  Info
└─────────────────────────────────────┘
```

### Detailed Specs

**Full Screen Layout**
- Background: #000000
- StatusBar: Light content
- SafeArea: All sides

**Top Bar** (Overlay)
- Padding: 16px horizontal, 12px vertical
- Background: Transparent

Left Side:
- Menu Icon: 26px
- Container: 40px × 40px
- Background: rgba(0, 0, 0, 0.3)
- Border Radius: 12px
- Backdrop Blur: 10px

Right Side:
- Logo Circle: 32px diameter
- Background: Purple gradient
- Text: "M" Cairo Bold 16px, white

**Right Action Buttons**
- Position: Right 12px, Bottom 120px
- Vertical Stack, Gap: 24px

Each Button:
- Container: 40px × 40px
- Border Radius: 20px
- Background: rgba(0, 0, 0, 0.3)
- Backdrop Blur: 10px
- Icon: 28px white
- Count Below: Cairo SemiBold 10px, white
- Text Shadow: 0 2px 4px rgba(0, 0, 0, 0.4)

Action Icons:
1. Heart (Like)
2. Chat Bubble (Comment)
3. Share Arrow
4. Bookmark

**Bottom Info Panel**
- Position: Bottom 0, SafeArea
- Padding: 16px
- Right Margin: 80px (space for actions)
- Background: Gradient overlay
  - Top: transparent
  - Bottom: rgba(0, 0, 0, 0.6)

User Row:
- Avatar: 32px circle, purple gradient background
- Name: Cairo SemiBold 14px, white
- Follow Button:
  - Size: Auto × 32px
  - Padding: 0 16px
  - Background: #FFFFFF
  - Border Radius: 16px
  - Text: Cairo SemiBold 13px, #1A1A1A
  - Gap: 10px

Caption:
- Font: Cairo Regular 12px
- Color: #FFFFFF
- Max Lines: 2
- Margin Top: 10px
- Text Shadow: 0 2px 4px rgba(0, 0, 0, 0.4)

Music Row:
- Margin Top: 10px
- Gap: 6px
- Icon: 14px music note
- Text: Cairo Regular 11px, white
- Rotating Disc: 28px circle, purple gradient
  - Animation: 3s linear infinite

---

## 📱 Screen 3: Stores (المتاجر)

### Visual Layout
```
┌─────────────────────────────────────┐
│  [Title: المتاجر] 20px SemiBold    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔍 ابحث عن متجر...         │   │
│  └─────────────────────────────┘   │
│                                     │
│   ◉     ◉     ◉     ◉             │
│  Store Store Store Store           │  Store Grid
│                                     │  (4 columns)
│   ◉     ◉     ◉     ◉             │
│  Store Store Store Store           │
│                                     │
│   ◉     ◉     ◉     ◉             │
│  Store Store Store Store           │
│                                     │
└─────────────────────────────────────┘
```

### Detailed Specs

**Header**
- Padding: 16px
- Title: "المتاجر"
  - Font: Cairo SemiBold 20px
  - Color: #1A1A1A

**Search Bar**
- Same as Home screen
- Margin: 12px top, 20px bottom

**Store Grid**
- Padding: 16px
- Columns: 4
- Column Gap: 16px
- Row Gap: 20px
- Child Aspect Ratio: 0.75

**Store Circle Item**

Outer Ring (if boosted):
- Diameter: 70px
- Border: 2px purple gradient
- Border Radius: 50%
- Padding: 2px
- Background: Gradient (Purple → Pink)

Inner Circle:
- Diameter: 66px
- Background: #F7F7F9
- Border: 3px #FFFFFF
- Border Radius: 50%
- Shadow: 0 2px 6px rgba(0, 0, 0, 0.08)

Store Initial:
- Font: Cairo Bold 28px
- Color: #7B2CF5
- Center aligned

Store Name:
- Margin Top: 6px
- Font: Cairo Medium 12px
- Color: #1A1A1A
- Max Lines: 1
- Overflow: Ellipsis
- Text Align: Center

---

## 📱 Screen 4: Cart (السلة)

### Visual Layout
```
┌─────────────────────────────────────┐
│  [Title: السلة] [Badge: 3]         │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [Img] Product Name      [×] │   │
│  │       Size: M               │   │
│  │       [- 1 +]      199 ر.س  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [Img] Product Name      [×] │   │
│  │       Size: L               │   │
│  │       [- 2 +]      398 ر.س  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ المجموع الفرعي:    597 ر.س  │   │
│  │ الشحن:             مجاني     │   │
│  │ ─────────────────────────   │   │
│  │ الإجمالي:          597 ر.س  │   │
│  │                             │   │
│  │     [إتمام الطلب]           │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Detailed Specs

**Header**
- Title: "السلة" Cairo SemiBold 20px
- Badge: Circle 20px, purple background, white number
- Padding: 16px

**Cart Item Card**
- Background: #FFFFFF
- Border Radius: 12px
- Padding: 12px
- Margin: 8px 16px
- Shadow: 0 1px 3px rgba(0, 0, 0, 0.06)

Item Layout (Row):
- Product Image:
  - Size: 80px × 80px
  - Border Radius: 10px
  - Background: #F7F7F9
  - Margin Right: 12px

- Info Column:
  - Product Name: Cairo Medium 14px, #1A1A1A
  - Variant: Cairo Regular 12px, #6A6A6A
  - Margin Bottom: 8px

- Quantity Controls:
  - Height: 32px
  - Border Radius: 10px
  - Background: #F7F7F9
  - Buttons: 32px squares
  - Number: Cairo Medium 14px

- Price:
  - Position: Top right
  - Font: Cairo Bold 16px
  - Color: #7B2CF5

- Remove Button:
  - Size: 28px × 28px
  - Icon: 18px × mark
  - Color: #9A9A9A
  - Position: Top right corner

**Summary Card**
- Background: #F5F0FF (Purple tint)
- Border Radius: 16px
- Padding: 20px
- Margin: 16px
- Border: 1px #E6E6E8

Summary Rows:
- Font: Cairo Regular 14px
- Color: #6A6A6A
- Value: Cairo SemiBold 16px, #1A1A1A
- Spacing: 12px between rows

Total Row:
- Separator: 1px #E6E6E8
- Margin: 12px vertical
- Label: Cairo SemiBold 16px
- Value: Cairo Bold 20px, #7B2CF5

Checkout Button:
- Width: 100%
- Height: 48px
- Background: #7B2CF5
- Border Radius: 14px
- Text: Cairo SemiBold 16px, white
- Margin Top: 16px
- Shadow: 0 4px 12px rgba(123, 44, 245, 0.3)

---

## 📱 Screen 5: Map (الخريطة - Placeholder)

### Visual Layout
```
┌─────────────────────────────────────┐
│  [Title: الخريطة] 20px SemiBold    │
│                                     │
│                                     │
│              🗺️                     │
│         (64px icon)                │
│                                     │
│      ميزة الخريطة قريباً           │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Detailed Specs

**Header**
- Padding: 16px
- Title: "الخريطة" Cairo SemiBold 20px

**Placeholder Content**
- Center aligned
- Vertical center

Icon:
- Map placeholder icon
- Size: 64px
- Color: #9A9A9A
- Margin Bottom: 16px

Text:
- Font: Cairo Regular 16px
- Color: #6A6A6A
- Text: "ميزة الخريطة قريباً"

---

## 📱 Screen 6: Merchant Dashboard (لوحة التحكم)

### Visual Layout
```
┌─────────────────────────────────────┐
│         [Purple Gradient]           │
│    [@Avatar] 64px                   │
│    Store Name (18px)                │
│    [Badge: تاجر]                    │
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │ [💰]     │  │ [📦]     │       │
│  │ 12,500   │  │ 45       │       │  Stats Grid
│  │ المبيعات │  │ الطلبات  │       │
│  └──────────┘  └──────────┘       │
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │ [⭐]     │  │ [👥]     │       │
│  │ 4.8      │  │ 1,234    │       │
│  │ التقييم  │  │ العملاء  │       │
│  └──────────┘  └──────────┘       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [📊] إدارة المنتجات      › │   │  Menu Items
│  ├─────────────────────────────┤   │
│  │ [📦] الطلبات الجديدة      › │   │
│  ├─────────────────────────────┤   │
│  │ [💰] المحفظة والإيرادات   › │   │
│  └─────────────────────────────┘   │
│                                     │
│                            [+] FAB  │
└─────────────────────────────────────┘
```

### Detailed Specs

**Header Section**
- Height: 140px
- Background: linear-gradient(135deg, #7B2CF5, #A46CFF)
- Padding: 20px

Avatar:
- Size: 64px circle
- Background: #FFFFFF
- Border: 3px white
- Shadow: 0 4px 12px rgba(0, 0, 0, 0.15)
- Initial: Cairo Bold 28px, Purple
- Margin Bottom: 12px

Store Name:
- Font: Cairo SemiBold 18px
- Color: #FFFFFF
- Margin Bottom: 6px

Role Badge:
- Height: 24px
- Padding: 0 12px
- Background: #FFFFFF
- Border Radius: 12px
- Text: Cairo Medium 12px, #7B2CF5
- Text: "تاجر"

**Stats Grid**
- Columns: 2
- Gap: 12px
- Padding: 16px
- Margin Top: -30px (overlap header)

**Stat Card**
- Background: linear-gradient(135deg, #F5F0FF, #FFFFFF)
- Border Radius: 16px
- Border: 1px #E6E6E8
- Padding: 20px
- Shadow: 0 2px 8px rgba(0, 0, 0, 0.04)

Stat Card Content:
- Icon Container:
  - Size: 48px × 48px
  - Border Radius: 12px
  - Background: Purple gradient
  - Icon: 24px white
  - Margin Bottom: 12px

- Number:
  - Font: Cairo Bold 24px
  - Color: #1A1A1A
  - Margin Bottom: 4px

- Label:
  - Font: Cairo Regular 13px
  - Color: #6A6A6A

- Trend (optional):
  - Small chip: 20px height
  - Background: Success/Error light
  - Text: Cairo Medium 11px
  - Arrow icon: 12px

**Menu Section**
- Padding: 16px
- Margin Top: 20px

Menu Item:
- Height: 56px
- Background: #FFFFFF
- Border Bottom: 1px #E6E6E8
- Padding: 0 16px
- Row layout

Left Side:
- Icon Container: 40px × 40px
- Background: #F7F7F9
- Border Radius: 10px
- Icon: 24px purple
- Margin Right: 12px

Center:
- Title: Cairo Medium 15px, #1A1A1A
- Subtitle: Cairo Regular 12px, #6A6A6A

Right:
- Chevron: 20px, #9A9A9A

Hover:
- Background: #F7F7F9

**Floating Action Button**
- Size: 56px × 56px
- Border Radius: 16px
- Background: Purple gradient
- Icon: 28px plus, white
- Shadow: 0 6px 20px rgba(123, 44, 245, 0.4)
- Position: Fixed bottom 16px, left 16px

---

## 📱 Screen 7: Profile (الملف الشخصي)

### Visual Layout
```
┌─────────────────────────────────────┐
│         [White Background]          │
│                                     │
│          [@Avatar] 80px             │
│          User Name                  │
│          user@email.com             │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [📦] طلباتي              › │   │
│  ├─────────────────────────────┤   │
│  │ [💰] محفظتي              › │   │
│  ├─────────────────────────────┤   │
│  │ [⭐] نقاطي               › │   │
│  ├─────────────────────────────┤   │
│  │ [❤️] المفضلة             › │   │
│  ├─────────────────────────────┤   │
│  │ [⚙️] الإعدادات           › │   │
│  └─────────────────────────────┘   │
│                                     │
│         [تسجيل الخروج]             │
│                                     │
└─────────────────────────────────────┘
```

### Detailed Specs

**Header Section**
- Background: #FFFFFF
- Padding: 32px 16px

Avatar:
- Size: 80px circle
- Background: Purple gradient or image
- Border: 4px white
- Shadow: 0 4px 16px rgba(0, 0, 0, 0.1)
- Center aligned

Name:
- Font: Cairo SemiBold 20px
- Color: #1A1A1A
- Margin Top: 16px
- Center aligned

Email:
- Font: Cairo Regular 14px
- Color: #6A6A6A
- Margin Top: 4px
- Center aligned

**Menu List**
- Margin: 24px 16px
- Background: #F7F7F9
- Border Radius: 16px
- Overflow: hidden

Menu Item: (Same as Dashboard)
- Height: 56px
- Separator: 1px #E6E6E8
- Icons: 24px
- Chevron: 20px right

**Logout Button**
- Width: calc(100% - 32px)
- Height: 48px
- Margin: 24px 16px
- Background: Transparent
- Border: 1.5px #FF4D4F
- Border Radius: 14px
- Text: Cairo SemiBold 15px, #FF4D4F
- Center aligned

---

## 🎨 Component Library

### 1. Buttons

**Primary Button**
```
┌────────────────────┐
│   Button Text      │  48px height
└────────────────────┘  14px radius
    Purple fill
```

**Secondary Button**
```
┌────────────────────┐
│   Button Text      │  48px height
└────────────────────┘  Purple border
    White fill

**Icon Button**
```
┌─────┐
│  ⚙  │  40px × 40px
└─────┘  10px radius
Surface fill
```

### 2. Cards

**Product Card**
```
┌────────────┐
│    📷      │  Image 1:1
│            │
│ Name       │  14px Medium
│ ★★★★★      │  11px
│ 199 ر.س    │  16px Bold Purple
└────────────┘  16px radius
```

**Stat Card**
```
┌────────────┐
│  [💰]      │  Icon 48px container
│  12,500    │  24px Bold
│  المبيعات  │  13px Regular
└────────────┘  16px radius, gradient
```

### 3. Inputs

**Text Input**
```
┌─────────────────────┐
│ Placeholder...      │  48px height
└─────────────────────┘  12px radius
    1.5px border
```

**Search Input**
```
┌──────────────────────┐
│ 🔍 ابحث...          │  44px height
└──────────────────────┘  22px radius (pill)
    No border, surface fill
```

### 4. Chips

**Filter Chip**
```
┌─────────┐
│  الكل   │  32px height
└─────────┘  16px radius
```

**Badge**
```
 ╭───╮
 │ 3 │  20px circle
 ╰───╯  Purple fill
```

---

## 🎯 Interaction States

### Buttons
- **Default**: Full color
- **Hover**: Darken 10%, lift shadow
- **Active**: Scale 0.98
- **Disabled**: Opacity 0.4

### Cards
- **Default**: Subtle shadow
- **Hover**: Lift shadow (0 4px 16px)
- **Active**: Scale 0.99

### Inputs
- **Default**: Light border
- **Focus**: Purple border + glow
- **Error**: Red border
- **Disabled**: Gray background

---

## 📐 Spacing & Layout Rules

### Page Structure
```
SafeArea
├── Padding 16px
├── Header (Title + Search)
├── Content (Scrollable)
└── Bottom Bar (Fixed)
```

### Content Spacing
- Section Gap: 24px
- Card Gap: 12-16px
- Element Gap: 8-12px
- Tight Gap: 4-6px

### Grid Systems
- Products: 2 columns, 12px gap
- Stores: 4 columns, 16px gap
- Dashboard Stats: 2 columns, 12px gap

---

## ✅ Design Validation Checklist

- [ ] All text uses Cairo font
- [ ] Purple (#7B2CF5) is primary color
- [ ] Border radius: 12px inputs, 16px cards
- [ ] Shadows are soft (0.04-0.08 alpha)
- [ ] Stats/prices use Bold weight
- [ ] RTL layout for Arabic
- [ ] Icons are 26-28px for actions
- [ ] Spacing multiples of 4px
- [ ] White/Surface backgrounds only
- [ ] Gradient only on CTAs and active states

---

**Document Version**: 1.0  
**Ready for**: Figma Design + Flutter Implementation  
**Style**: Meta AI × mBuy Purple Identity
