# mBuy Figma Design Guide
## How to Build the Design System in Figma

---

## 📁 File Structure

```
mBuy Design System/
├── 🎨 Cover Page
├── 📋 Design Tokens
├── 🎯 Foundation
│   ├── Colors
│   ├── Typography
│   ├── Icons
│   ├── Spacing
│   └── Shadows
├── 🧩 Components
│   ├── Buttons
│   ├── Cards
│   ├── Inputs
│   ├── Chips
│   └── Navigation
├── 📱 Screens - Customer
│   ├── Home
│   ├── Explore (Reels)
│   ├── Stores
│   ├── Cart
│   ├── Map
│   └── Profile
├── 📊 Screens - Merchant
│   ├── Dashboard
│   ├── Products
│   ├── Orders
│   └── Wallet
└── 📖 Documentation
```

---

## 🎨 Step 1: Setup Foundation

### Colors Page

Create color styles:

**Primary Palette**
```
Name: Primary/Purple          Value: #7B2CF5
Name: Primary/Light           Value: #A46CFF
Name: Primary/Dark            Value: #5320A0
Name: Primary/Subtle          Value: #F5F0FF
```

**Neutrals**
```
Name: Background              Value: #FFFFFF
Name: Surface                 Value: #F7F7F9
Name: Surface/Dark            Value: #F0F0F2
Name: Border/Light            Value: #E6E6E8
Name: Border                  Value: #D0D0D2
```

**Text**
```
Name: Text/Primary            Value: #1A1A1A
Name: Text/Secondary          Value: #6A6A6A
Name: Text/Tertiary           Value: #9A9A9A
Name: Text/Inverse            Value: #FFFFFF
```

**Status**
```
Name: Success                 Value: #22CC88
Name: Success/Light           Value: #E6F9F0
Name: Error                   Value: #FF4D4F
Name: Error/Light             Value: #FFF0F0
Name: Warning                 Value: #FFA940
Name: Warning/Light           Value: #FFF7E6
```

**Gradients**
```
Name: Gradient/Purple
Type: Linear
Angle: 135°
Stops: #7B2CF5 (0%) → #A46CFF (100%)

Name: Gradient/Subtle
Type: Linear
Angle: 180°
Stops: #F5F0FF (0%) → #FFFFFF (100%)

Name: Gradient/Dark
Type: Linear
Angle: 135°
Stops: #5320A0 (0%) → #7B2CF5 (100%)
```

### Typography Styles

**Install Font**: Cairo (Google Fonts)
- Import all weights: 400, 500, 600, 700

**Create Text Styles**:

```
Name: Title/Hero
Font: Cairo SemiBold
Size: 28px
Line Height: 36px (129%)
Paragraph Spacing: 16px

Name: Title/Page
Font: Cairo SemiBold
Size: 20px
Line Height: 28px (140%)
Paragraph Spacing: 12px

Name: Title/Section
Font: Cairo Medium
Size: 17px
Line Height: 24px (141%)
Paragraph Spacing: 10px

Name: Body/Default
Font: Cairo Regular
Size: 14px
Line Height: 22px (157%)
Paragraph Spacing: 8px

Name: Body/Small
Font: Cairo Regular
Size: 12px
Line Height: 18px (150%)

Name: Caption
Font: Cairo Regular
Size: 11px
Line Height: 16px (145%)

Name: Stats/Numbers
Font: Cairo Bold
Size: 18px
Line Height: 24px (133%)
Letter Spacing: -0.2px
```

### Effect Styles (Shadows)

```
Name: Shadow/None
(No effects)

Name: Shadow/Subtle
Effect: Drop Shadow
X: 0, Y: 1, Blur: 3, Spread: 0
Color: #000000, Opacity: 4%

Name: Shadow/Card
Effect: Drop Shadow
X: 0, Y: 2, Blur: 8, Spread: 0
Color: #000000, Opacity: 6%

Name: Shadow/Elevated
Effect: Drop Shadow
X: 0, Y: 4, Blur: 16, Spread: 0
Color: #000000, Opacity: 8%

Name: Shadow/Floating
Effect: Drop Shadow
X: 0, Y: 8, Blur: 24, Spread: 0
Color: #000000, Opacity: 12%

Name: Shadow/Modal
Effect: Drop Shadow
X: 0, Y: 16, Blur: 48, Spread: 0
Color: #000000, Opacity: 16%

Name: Glow/Purple
Effect: Drop Shadow
X: 0, Y: 4, Blur: 20, Spread: 0
Color: #7B2CF5, Opacity: 30%
```

### Grid Styles

**Mobile Grid** (375px base)
```
Columns: 2
Gutter: 12px
Margin: 16px
```

**Layout Grid** (8px base)
```
Type: Grid
Size: 8px
Color: #7B2CF5, Opacity: 8%
```

---

## 🧩 Step 2: Build Components

### Component 1: Primary Button

**Frame Setup**
- Size: Auto × 48px
- Layout: Horizontal
- Padding: 16px horizontal, 14px vertical
- Gap: 8px
- Border Radius: 14px
- Fill: Primary/Purple
- Effect: Glow/Purple
- Auto Layout: Hug contents

**Text**
- Style: Body/Default → Cairo SemiBold 15px
- Color: Text/Inverse
- Alignment: Center

**Variants**
1. Default
2. Hover (Background: Primary/Dark)
3. Pressed (Scale: 98%)
4. Disabled (Opacity: 40%)

**With Icon** (Optional)
- Icon Size: 20px
- Position: Left of text
- Gap: 8px

### Component 2: Secondary Button

**Same structure as Primary but:**
- Fill: Background (#FFFFFF)
- Stroke: 1.5px, Primary/Purple
- Text Color: Primary/Purple
- No glow
- Hover: Background → Primary/Subtle

### Component 3: Icon Button

**Frame Setup**
- Size: 40px × 40px
- Border Radius: 10px
- Fill: Surface
- Effect: Shadow/Subtle

**Icon**
- Size: 26px
- Color: Primary/Purple

**Variants**
- Default
- Hover (Background: Surface/Dark)
- Active (Background: Primary/Purple, Icon: white)
- Disabled (Opacity: 40%)

### Component 4: Product Card

**Frame Setup**
- Size: Auto × Auto
- Layout: Vertical
- Padding: 12px
- Gap: 10px
- Border Radius: 16px
- Fill: Background
- Effect: Shadow/Card

**Image Container**
- Aspect Ratio: 1:1 (Square)
- Border Radius: 12px
- Fill: Surface
- Placeholder: Icon or image

**Content Stack**
- Gap: 6px

**Product Name**
- Style: Body/Default → Cairo Medium 14px
- Color: Text/Primary
- Max Lines: 2
- Overflow: Ellipsis

**Rating Row**
- Layout: Horizontal
- Gap: 4px
- Stars: 14px, #FFA940
- Count: Caption, Text/Tertiary

**Price**
- Style: Stats/Numbers → Cairo Bold 16px
- Color: Primary/Purple

**Variants**
- Default
- Hover (Shadow: Shadow/Elevated)
- Selected (Border: 2px Primary/Purple)

### Component 5: Stat Card (Dashboard)

**Frame Setup**
- Size: Auto × Auto
- Layout: Vertical
- Padding: 20px
- Gap: 12px
- Border Radius: 16px
- Fill: Gradient/Subtle
- Stroke: 1px Border/Light
- Effect: Shadow/Card

**Icon Container**
- Size: 48px × 48px
- Border Radius: 12px
- Fill: Gradient/Purple
- Icon: 24px white

**Number**
- Style: Cairo Bold 24px
- Color: Text/Primary

**Label**
- Style: Body/Small → Cairo Regular 13px
- Color: Text/Secondary

**Trend Chip** (Optional)
- Height: 20px
- Padding: 0 8px
- Border Radius: 10px
- Background: Success/Light or Error/Light
- Icon: 12px arrow
- Text: Cairo Medium 11px

### Component 6: Text Input

**Frame Setup**
- Size: Fill × 48px
- Layout: Horizontal
- Padding: 0 16px
- Gap: 12px
- Border Radius: 12px
- Fill: Background
- Stroke: 1.5px Border/Light

**Placeholder Text**
- Style: Body/Default
- Color: Text/Tertiary

**Icon** (Optional)
- Size: 20px
- Color: Text/Secondary

**Variants**
- Default
- Focus (Stroke: Primary/Purple, Effect: Glow purple 10%)
- Error (Stroke: Error, Effect: Glow red 10%)
- Disabled (Fill: Surface/Dark, Opacity: 60%)

### Component 7: Search Input

**Frame Setup**
- Size: Fill × 44px
- Layout: Horizontal
- Padding: 0 16px 0 48px
- Border Radius: 22px (Pill)
- Fill: Surface
- No Stroke

**Search Icon**
- Size: 26px
- Position: Absolute right 16px
- Color: Text/Secondary

**Placeholder**
- Style: Body/Default
- Color: Text/Tertiary

### Component 8: Filter Chip

**Frame Setup**
- Size: Auto × 32px
- Layout: Horizontal
- Padding: 0 16px
- Border Radius: 16px
- Gap: 6px

**Variants**

Unselected:
- Fill: Background
- Stroke: 1px Border/Light
- Text: Text/Secondary

Selected:
- Fill: Primary/Purple
- No Stroke
- Text: Text/Inverse

### Component 9: Store Circle

**Outer Ring** (Story Ring)
- Size: 70px × 70px
- Border Radius: 50%
- Stroke: 2px Gradient/Purple
- Padding: 2px
- Visible: If boosted = true

**Inner Circle**
- Size: 66px × 66px
- Border Radius: 50%
- Fill: Surface
- Stroke: 3px white
- Effect: Shadow/Card

**Initial Letter**
- Style: Cairo Bold 28px
- Color: Primary/Purple
- Position: Center

**Store Name**
- Below circle
- Style: Body/Small → Cairo Medium 12px
- Color: Text/Primary
- Max Lines: 1
- Center aligned

### Component 10: Bottom Navigation Bar

**Frame Setup**
- Size: Fill × 64px
- Layout: Horizontal
- Padding: 8px 16px
- Gap: Distribute evenly
- Fill: #000000, Opacity: 70%
- Effect: Backdrop Blur 20px

**Tab Item**
- Size: 40px × 40px
- Layout: Vertical
- Gap: 4px

**Icon**
- Size: 26px

**Variants per tab**

Unselected:
- Icon Color: White, Opacity: 60%

Selected:
- Icon: Apply Gradient/Purple with layer styles
  (Use gradient as fill on icon)

**5 Tabs**
1. Explore
2. Stores
3. Home
4. Cart
5. Map

### Component 11: Action Button (Reels)

**Frame Setup**
- Size: 40px × 40px
- Layout: Vertical
- Gap: 4px
- Align: Center

**Icon Container**
- Size: 40px × 40px
- Border Radius: 20px
- Fill: #000000, Opacity: 30%
- Effect: Backdrop Blur 10px

**Icon**
- Size: 28px
- Color: White

**Count**
- Style: Cairo SemiBold 10px
- Color: White
- Effect: Text shadow (Y: 2, Blur: 4, #000000 40%)

---

## 📱 Step 3: Design Screens

### Home Screen

**Canvas Size**: 375 × 812 (iPhone X)

**Structure**
```
SafeArea Frame
├── Header
│   ├── Title: "الرئيسية"
│   ├── Search Bar Component
│   └── Filter Chips (Auto Layout Horizontal)
├── Product Grid (Auto Layout Wrap)
│   ├── Product Card Component × N
│   └── Gap: 12px
└── Bottom Nav Component (Fixed)
```

**Details**
- Background: Background color
- Padding: 16px
- Title: 16px top padding
- Grid: 2 columns, 12px gap
- Scroll: Vertical

### Explore Screen (Reels)

**Canvas Size**: 375 × 812

**Structure**
```
Full Screen Frame
├── Background: #000000
├── Video Placeholder (Gradient)
├── Top Bar
│   ├── Menu Icon Button
│   └── Logo Circle (Right)
├── Right Actions Stack
│   ├── Like Button
│   ├── Comment Button
│   ├── Share Button
│   └── Bookmark Button
└── Bottom Info
    ├── User Row (Avatar + Name + Follow)
    ├── Caption
    └── Music Row
```

**Details**
- StatusBar: Light
- Overlay elements on video
- Gradient overlay at bottom

### Stores Screen

**Canvas Size**: 375 × 812

**Structure**
```
SafeArea Frame
├── Header
│   ├── Title: "المتاجر"
│   └── Search Bar Component
├── Store Grid (Auto Layout Wrap)
│   ├── Store Circle Component × N
│   └── Gap: 16px horizontal, 20px vertical
└── Bottom Nav Component (Fixed)
```

**Details**
- Grid: 4 columns
- Aspect Ratio: 0.75 per item
- Story rings on boosted stores

### Cart Screen

**Canvas Size**: 375 × 812

**Structure**
```
SafeArea Frame
├── Header
│   ├── Title: "السلة"
│   └── Badge: Items count
├── Cart Items (Vertical Stack)
│   ├── Cart Item Card × N
│   └── Gap: 8px
├── Summary Card
│   ├── Subtotal
│   ├── Shipping
│   ├── Divider
│   ├── Total
│   └── Checkout Button
└── Bottom Nav Component (Fixed)
```

### Merchant Dashboard

**Canvas Size**: 375 × 812

**Structure**
```
SafeArea Frame
├── Header (Purple Gradient)
│   ├── Avatar
│   ├── Store Name
│   └── Role Badge
├── Stats Grid
│   ├── Sales Card
│   ├── Orders Card
│   ├── Rating Card
│   └── Customers Card
├── Menu List
│   ├── Menu Item × N
│   └── Dividers
└── FAB (Fixed bottom right)
```

---

## 🎯 Step 4: Create Variants & Auto Layout

### Button Variants

Create component set:
```
Property 1: Type
- Primary
- Secondary
- Ghost

Property 2: Size
- Large (48px)
- Medium (40px)
- Small (36px)

Property 3: State
- Default
- Hover
- Pressed
- Disabled

Property 4: Icon
- Yes
- No
```

### Card Variants

```
Property 1: Type
- Product
- Stat
- Cart Item

Property 2: State
- Default
- Hover
- Selected
```

### Input Variants

```
Property 1: Type
- Text
- Search
- Textarea

Property 2: State
- Default
- Focus
- Error
- Disabled
```

---

## 📐 Step 5: Setup Auto Layout Rules

### Responsive Behaviors

**Product Card**
- Width: Fill container
- Height: Hug contents
- Resizing: Fill horizontally, Hug vertically

**Button**
- Width: Fill or Hug (based on usage)
- Height: Fixed (48px)
- Resizing: Fill horizontally, Fixed vertically

**Input**
- Width: Fill container
- Height: Fixed (48px)
- Resizing: Fill horizontally, Fixed vertically

### Layout Grids

**Home Grid**
```
Type: Auto Layout
Direction: Horizontal
Wrap: Yes
Gap: 12px
Padding: 16px
```

**Stores Grid**
```
Type: Auto Layout
Direction: Horizontal
Wrap: Yes
Gap: 16px horizontal, 20px vertical
Padding: 16px
```

---

## 🎨 Step 6: Design Token Plugin

**Recommended Plugins**:
1. **Tokens Studio** for design tokens
2. **Iconify** for consistent icons
3. **Unsplash** for placeholder images
4. **Content Reel** for Arabic text samples

**Export tokens.json**:
```json
{
  "color": {
    "primary": {
      "purple": "#7B2CF5",
      "light": "#A46CFF",
      "dark": "#5320A0"
    },
    "background": "#FFFFFF",
    "surface": "#F7F7F9",
    "text": {
      "primary": "#1A1A1A",
      "secondary": "#6A6A6A"
    }
  },
  "font": {
    "family": "Cairo",
    "size": {
      "title": "20px",
      "body": "14px",
      "small": "12px",
      "stats": "18px"
    }
  },
  "spacing": {
    "small": "12px",
    "medium": "16px",
    "large": "24px"
  },
  "radius": {
    "medium": "12px",
    "large": "16px",
    "pill": "999px"
  }
}
```

---

## 📤 Step 7: Export Assets

### For Development

**iOS Assets**
```
Export: @1x, @2x, @3x
Format: PNG (icons), PDF (vectors)
Naming: icon_name@2x.png
```

**Android Assets**
```
Export: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi
Format: PNG, WebP
Naming: ic_name.png
```

**Flutter Assets**
```
Export: @1x, @2x, @3x
Format: SVG (preferred), PNG
Folder: assets/icons/, assets/images/
```

### Design Specs

**Use Inspect Panel**:
- Copy CSS
- Copy iOS/Android code
- Export measurements
- Share with developers

**Dev Handoff**:
1. Share Figma link (View access)
2. Enable Dev Mode
3. Mark ready for development
4. Add implementation notes
5. Link to design system docs

---

## ✅ Figma Checklist

### Foundation
- [ ] All colors defined as styles
- [ ] Cairo font installed and used
- [ ] Text styles created (Title, Body, Stats, etc.)
- [ ] Shadow effects defined
- [ ] Grid layout configured

### Components
- [ ] Primary Button with variants
- [ ] Secondary Button with variants
- [ ] Icon Button with states
- [ ] Product Card component
- [ ] Stat Card component
- [ ] Text Input with variants
- [ ] Search Input
- [ ] Filter Chips
- [ ] Store Circle with story ring
- [ ] Bottom Navigation Bar
- [ ] Action Buttons (Reels)
- [ ] FAB Button

### Screens - Customer
- [ ] Home Screen
- [ ] Explore Screen (Reels)
- [ ] Stores Screen
- [ ] Cart Screen
- [ ] Map Screen (Placeholder)
- [ ] Profile Screen

### Screens - Merchant
- [ ] Dashboard with stats
- [ ] Products Management
- [ ] Orders List
- [ ] Wallet Screen

### Documentation
- [ ] Component descriptions
- [ ] Usage guidelines
- [ ] Spacing rules
- [ ] Color usage notes
- [ ] Typography scale
- [ ] Export instructions

### Developer Handoff
- [ ] Dev Mode enabled
- [ ] Inspect panel accessible
- [ ] Assets exported
- [ ] Design tokens documented
- [ ] Implementation notes added

---

## 🎬 Animation Specifications

### Micro-interactions

**Button Press**
```
Property: Scale
From: 1.0
To: 0.98
Duration: 150ms
Easing: Ease Out
```

**Card Hover**
```
Property: Shadow
From: Shadow/Card
To: Shadow/Elevated
Duration: 200ms
Easing: Ease Out
```

**Page Transition**
```
Property: Position X
From: 100%
To: 0%
Duration: 300ms
Easing: Ease In Out
```

**FAB Appear**
```
Property: Scale + Opacity
From: 0, 0
To: 1, 1
Duration: 400ms
Easing: Spring (Bounce)
Delay: 200ms
```

**Skeleton Loading**
```
Property: Background Position
From: -200%
To: 200%
Duration: 1500ms
Easing: Linear
Repeat: Infinite
```

---

## 🔧 Figma Plugins Recommendations

1. **Tokens Studio**: Manage design tokens
2. **Iconify**: 100k+ icons library
3. **Unsplash**: Free high-quality images
4. **Content Reel**: Generate Arabic text
5. **Figma to Flutter**: Export to Flutter code
6. **Contrast**: Check color accessibility
7. **Stark**: Accessibility checker
8. **Autoflow**: Create user flows
9. **FigJam**: Brainstorming and ideation
10. **Mockup**: Device mockups

---

## 📚 Resources

**Cairo Font**
- Google Fonts: fonts.google.com/specimen/Cairo
- Download all weights (400, 500, 600, 700)

**Icon Libraries**
- Iconify: iconify.design
- Feather Icons: feathericons.com
- Heroicons: heroicons.com

**Images**
- Unsplash: unsplash.com
- Pexels: pexels.com
- Placeholder: placeholder.com

**Arabic Content**
- Arabic Lorem Ipsum: ar.lipsum.com
- Random Arabic Names: generators.com

---

**Guide Version**: 1.0  
**Tool**: Figma  
**Design System**: mBuy × Meta AI Style  
**Ready for**: Implementation in Flutter
