# mBuy Design System
## Meta AI Style × mBuy Purple Identity

---

## 🎨 Design Philosophy

**Inspired by**: Meta AI Clean Interface  
**Brand Identity**: mBuy Purple × White  
**Style**: Minimal, Clean, Spacious, Modern  
**Vibe**: Professional yet friendly, Tech-forward

---

## 🌈 Color Tokens

### Primary Colors
```
Primary:         #7B2CF5  (mBuy Purple)
Primary Light:   #A46CFF  (Soft Purple)
Primary Dark:    #5320A0  (Deep Purple)
Primary Subtle:  #F5F0FF  (Background Tint)
```

### Neutrals
```
Background:      #FFFFFF  (Pure White)
Surface:         #F7F7F9  (Soft Gray)
Surface Dark:    #F0F0F2  (Card Hover)
Border Light:    #E6E6E8  (Dividers)
Border:          #D0D0D2  (Input Borders)
```

### Text Colors
```
Text Primary:    #1A1A1A  (Main Content)
Text Secondary:  #6A6A6A  (Descriptions)
Text Tertiary:   #9A9A9A  (Placeholders)
Text Inverse:    #FFFFFF  (On Purple)
```

### Status Colors
```
Success:         #22CC88  (Green)
Success Light:   #E6F9F0  (Background)
Error:           #FF4D4F  (Red)
Error Light:     #FFF0F0  (Background)
Warning:         #FFA940  (Orange)
Warning Light:   #FFF7E6  (Background)
Info:            #40A9FF  (Blue)
Info Light:      #E6F7FF  (Background)
```

### Gradients
```
Purple Gradient: linear-gradient(135deg, #7B2CF5 0%, #A46CFF 100%)
Subtle Gradient: linear-gradient(180deg, #F5F0FF 0%, #FFFFFF 100%)
Dark Gradient:   linear-gradient(135deg, #5320A0 0%, #7B2CF5 100%)
```

---

## ✍️ Typography System
**Font Family**: Cairo (Google Fonts)

### Weights
- **SemiBold (600)**: Titles, Headers
- **Medium (500)**: Subtitles, Labels
- **Regular (400)**: Body, Paragraphs
- **Bold (700)**: Numbers, Stats, Prices

### Scale

| Name          | Size | Weight   | Line Height | Usage                    |
|---------------|------|----------|-------------|--------------------------|
| **Hero**      | 28px | SemiBold | 36px        | Landing Pages            |
| **Title**     | 20px | SemiBold | 28px        | Screen Headers           |
| **Subtitle**  | 17px | Medium   | 24px        | Section Titles           |
| **Body**      | 14px | Regular  | 22px        | Main Content             |
| **Small**     | 12px | Regular  | 18px        | Supporting Text          |
| **Caption**   | 11px | Regular  | 16px        | Hints, Metadata          |
| **Stats**     | 18px | Bold     | 24px        | Numbers, Prices, Metrics |

### Arabic Text Settings
```
Letter Spacing: 0px (Natural)
Text Direction: RTL
Alignment: Right for paragraphs
Font Features: Arabic numerals optional
```

---

## 🔲 Icon System

### Style Guidelines
- **Type**: Rounded Corners (12% radius on squares)
- **Stroke Weight**: 1.8pt
- **Style**: Minimal, Modern, Consistent
- **Inspired by**: Meta icons but with mBuy identity

### Icon Sizes

| Context              | Size | Usage                           |
|----------------------|------|---------------------------------|
| **Action Icons**     | 28px | Like, Comment, Share, Heart     |
| **Navigation Icons** | 26px | Menu, Settings, Profile, Back   |
| **CTA Large**        | 36px | Main + button, FAB              |
| **Bottom Bar**       | 26px | Tab Bar Icons                   |
| **Small Icons**      | 20px | Inline icons, Badges            |
| **Micro Icons**      | 16px | Input suffixes, Chips           |

### Icon Colors
```
Primary:    #7B2CF5  (Active state)
Default:    #6A6A6A  (Inactive)
Light:      #9A9A9A  (Disabled)
Inverse:    #FFFFFF  (On purple)
```

---

## 📐 Spacing System
**Base Unit**: 4px

```
Micro:    4px   (Chips, Badges)
Tiny:     8px   (Between small elements)
Small:    12px  (Card content spacing)
Medium:   16px  (Standard padding)
Large:    24px  (Section spacing)
XLarge:   32px  (Page margins)
XXLarge:  48px  (Hero sections)
```

---

## 🔘 Button System

### Primary Button
```
Background:      #7B2CF5
Text Color:      #FFFFFF
Border Radius:   14px
Height:          48px
Padding:         16px horizontal
Font:            Cairo SemiBold 15px
Shadow:          0 2px 8px rgba(123, 44, 245, 0.2)
Hover:           #5320A0
Active:          #5320A0 + scale(0.98)
```

### Secondary Button
```
Background:      #FFFFFF
Text Color:      #7B2CF5
Border:          1.5px solid #7B2CF5
Border Radius:   14px
Height:          48px
Padding:         16px horizontal
Font:            Cairo SemiBold 15px
Hover:           #F5F0FF background
```

### Ghost Button
```
Background:      Transparent
Text Color:      #7B2CF5
Border:          None
Font:            Cairo Medium 14px
Hover:           #F5F0FF background
```

### Icon Button
```
Size:            40px × 40px
Border Radius:   10px
Background:      #F7F7F9
Icon:            26px
Hover:           #E6E6E8
Active:          #7B2CF5 background, white icon
```

### Small Button
```
Height:          36px
Border Radius:   10px
Padding:         12px horizontal
Font:            Cairo Medium 13px
```

---

## 🃏 Card System

### Standard Card
```
Background:      #F7F7F9
Border Radius:   16px
Padding:         16px
Shadow:          0 1px 3px rgba(0, 0, 0, 0.04)
Border:          None
Hover:           0 2px 8px rgba(0, 0, 0, 0.08)
```

### Elevated Card
```
Background:      #FFFFFF
Border Radius:   16px
Padding:         20px
Shadow:          0 2px 12px rgba(0, 0, 0, 0.06)
Border:          1px solid #E6E6E8
```

### Product Card
```
Background:      #FFFFFF
Border Radius:   16px
Padding:         12px
Shadow:          0 1px 4px rgba(0, 0, 0, 0.06)
Image Radius:    12px
Aspect Ratio:    0.75 (3:4)
```

### Stats Card (Dashboard)
```
Background:      linear-gradient(135deg, #F5F0FF 0%, #FFFFFF 100%)
Border Radius:   16px
Padding:         20px
Border:          1px solid #E6E6E8
Icon Container:  48px × 48px, radius 12px, purple gradient
Number:          Cairo Bold 24px
Label:           Cairo Regular 13px, #6A6A6A
```

---

## 📝 Input System

### Text Input
```
Height:          48px
Border Radius:   12px
Border:          1.5px solid #E6E6E8
Background:      #FFFFFF
Padding:         0 16px
Font:            Cairo Regular 14px
Placeholder:     #9A9A9A

Focus State:
Border:          1.5px solid #7B2CF5
Shadow:          0 0 0 3px rgba(123, 44, 245, 0.1)

Error State:
Border:          1.5px solid #FF4D4F
```

### Search Input
```
Height:          44px
Border Radius:   22px (Pill shape)
Border:          None
Background:      #F7F7F9
Padding:         0 16px 0 48px
Font:            Cairo Regular 14px
Icon:            26px magnifier, left side, #6A6A6A
```

### Textarea
```
Min Height:      100px
Border Radius:   12px
Border:          1.5px solid #E6E6E8
Padding:         12px 16px
Font:            Cairo Regular 14px
```

---

## 📱 Screen Layouts

### 1. Home Screen (الرئيسية)
```
Header:
- Title: "الرئيسية" - Cairo SemiBold 20px
- Search Bar: Pill shape, 44px height, Surface background
- Filter Chips: 32px height, 12px radius, spacing 8px

Product Grid:
- Columns: 2
- Gap: 12px
- Padding: 16px
- Aspect Ratio: 0.75
- Card: White, 16px radius, soft shadow

Bottom Bar:
- Height: 64px
- Background: Black alpha 0.7
- Icons: 26px
- Selected: Purple gradient
```

### 2. Explore Screen (اكتشف)
```
Layout: Full screen vertical reels

Right Side Actions:
- Icon Size: 28px
- Container: 40px × 40px
- Background: Black alpha 0.3
- Spacing: 24px between icons
- Icons: Like, Comment, Share, Bookmark

Bottom Info:
- Avatar: 32px radius
- Name: Cairo SemiBold 14px
- Caption: Cairo Regular 12px
- Music: 28px rotating disc
- Follow Button: 36px × 100px, white, 18px radius

Top Bar:
- Menu Icon: 26px in 40px container
- Logo: 32px circle with purple gradient
```

### 3. Stores Screen (المتاجر)
```
Header:
- Title: "المتاجر" - Cairo SemiBold 20px
- Search Bar: Pill shape, 44px

Grid Layout:
- Columns: 4
- Store Circle: 66px diameter
- Story Ring: 70px (if boosted)
- Ring Color: Purple gradient
- Gap: 16px horizontal, 20px vertical
- Name: Cairo Medium 12px, centered

Store Circle:
- Background: Surface
- Border: 3px white
- Shadow: Soft
- Initial Letter: Cairo Bold 28px, Purple
```

### 4. Map Screen (الخريطة)
```
Layout: Simplified placeholder

Header:
- Title: "الخريطة" - Cairo SemiBold 20px
- Padding: 16px

Content:
- Icon: Map placeholder 64px, #6A6A6A
- Text: Cairo Regular 16px, #6A6A6A
- Message: "ميزة الخريطة قريباً"
- Center aligned
```

### 5. Cart Screen (السلة)
```
Header:
- Title: "السلة" - Cairo SemiBold 20px
- Badge: Items count, purple circle

Cart Items:
- Card: White, 12px radius
- Product Image: 80px × 80px, 10px radius
- Name: Cairo Medium 14px
- Price: Cairo Bold 16px, Purple
- Quantity Controls: 32px height, 10px radius
- Remove: 24px icon button

Summary Card:
- Background: Purple subtle
- Padding: 20px
- Subtotal/Total: Cairo Bold 18px
- Checkout Button: Full width, 48px
```

---

## 👤 Merchant Dashboard

### Layout Structure
```
Header:
- Background: Purple gradient
- Height: 120px
- Avatar: 64px white circle
- Name: Cairo SemiBold 18px, white
- Role Badge: "تاجر" 24px height, white background

Stats Grid:
- Columns: 2
- Gap: 12px
- Padding: 16px

Stat Card:
- Background: Subtle gradient
- Border: 1px #E6E6E8
- Radius: 16px
- Padding: 20px
- Icon Container: 48px square, 12px radius, purple gradient
- Number: Cairo Bold 24px, #1A1A1A
- Label: Cairo Regular 13px, #6A6A6A
- Trend: Small chip with arrow, success/error color
```

### Menu Items (Facebook Style)
```
Item Height: 56px
Icon Container: 40px square, 10px radius, Surface background
Icon: 24px, purple
Title: Cairo Medium 15px
Subtitle: Cairo Regular 12px, #6A6A6A
Separator: 1px #E6E6E8
Hover: #F7F7F9 background
```

### Quick Actions
```
Action Button:
- Size: 56px × 56px
- Radius: 16px
- Background: Purple gradient
- Icon: 28px white
- Shadow: 0 4px 12px rgba(123, 44, 245, 0.3)
- Position: Fixed bottom right (+ 16px margin)
```

---

## 🎭 Component States

### Hover
```
Cards: Lift shadow (0 2px 8px → 0 4px 16px)
Buttons: Darken 10%
Icons: Scale 1.05
Links: Underline
```

### Active/Pressed
```
Buttons: Scale 0.98
Icons: Scale 0.95
Background: Darken 15%
```

### Disabled
```
Opacity: 0.4
Cursor: not-allowed
No hover effects
```

### Loading
```
Skeleton: #F0F0F2 shimmer
Spinner: Purple gradient rotating
Opacity: 0.6
```

---

## 🌟 Shadows & Elevation

```
Level 0 (Flat):         none
Level 1 (Subtle):       0 1px 3px rgba(0, 0, 0, 0.04)
Level 2 (Card):         0 2px 8px rgba(0, 0, 0, 0.06)
Level 3 (Elevated):     0 4px 16px rgba(0, 0, 0, 0.08)
Level 4 (Floating):     0 8px 24px rgba(0, 0, 0, 0.12)
Level 5 (Modal):        0 16px 48px rgba(0, 0, 0, 0.16)

Purple Glow:            0 4px 20px rgba(123, 44, 245, 0.3)
```

---

## 🔄 Animations & Transitions

```
Default Duration: 200ms
Timing Function:  ease-out

Button Press:     transform 150ms ease-out
Card Hover:       all 200ms ease-out
Modal Open:       opacity 250ms, scale 300ms spring
Page Transition:  slide 300ms ease-in-out
Skeleton:         shimmer 1500ms linear infinite
```

---

## 📐 Border Radius Scale

```
Micro:    4px   (Badges, small chips)
Small:    8px   (Input focus ring)
Medium:   12px  (Inputs, cards)
Large:    16px  (Cards, modals)
XLarge:   20px  (Hero sections)
Pill:     999px (Search bars, tags)
Circle:   50%   (Avatars, icon buttons)
```

---

## 🎨 Design Tokens (Ready for Export)

### Flutter Theme
```dart
// Colors
primaryPurple: Color(0xFF7B2CF5)
primaryLight: Color(0xFFA46CFF)
primaryDark: Color(0xFF5320A0)
background: Color(0xFFFFFFFF)
surface: Color(0xFFF7F7F9)
textPrimary: Color(0xFF1A1A1A)
textSecondary: Color(0xFF6A6A6A)

// Typography
fontFamily: 'Cairo'
titleSize: 20.0
bodySize: 14.0
statsSize: 18.0

// Spacing
spacingSmall: 12.0
spacingMedium: 16.0
spacingLarge: 24.0

// Borders
radiusMedium: 12.0
radiusLarge: 16.0
```

### CSS Variables
```css
--color-primary: #7B2CF5;
--color-primary-light: #A46CFF;
--color-primary-dark: #5320A0;
--color-background: #FFFFFF;
--color-surface: #F7F7F9;
--color-text-primary: #1A1A1A;
--color-text-secondary: #6A6A6A;

--font-family: 'Cairo', sans-serif;
--font-size-title: 20px;
--font-size-body: 14px;
--font-size-stats: 18px;

--spacing-small: 12px;
--spacing-medium: 16px;
--spacing-large: 24px;

--radius-medium: 12px;
--radius-large: 16px;

--shadow-card: 0 2px 8px rgba(0, 0, 0, 0.06);
--shadow-elevated: 0 4px 16px rgba(0, 0, 0, 0.08);
```

---

## 📱 Responsive Breakpoints

```
Mobile:     < 768px  (Single column, full width)
Tablet:     768px - 1024px (2 columns for products)
Desktop:    > 1024px (Not primary focus)

Grid Adjustments:
- Products: 2 cols mobile, 3 cols tablet
- Stores: 4 cols mobile, 6 cols tablet
- Dashboard: 2 cols always
```

---

## ✅ Checklist for Implementation

### Phase 1: Foundation
- [ ] Install Cairo font (Google Fonts)
- [ ] Define color tokens in theme
- [ ] Setup spacing constants
- [ ] Create base typography styles

### Phase 2: Components
- [ ] Button variants (Primary, Secondary, Ghost, Icon)
- [ ] Card components (Standard, Elevated, Product, Stats)
- [ ] Input components (Text, Search, Textarea)
- [ ] Icon system with consistent sizing

### Phase 3: Screens
- [ ] Home screen with product grid
- [ ] Explore screen (Reels style)
- [ ] Stores screen (Snapchat style)
- [ ] Cart screen
- [ ] Map screen (Placeholder)

### Phase 4: Merchant
- [ ] Dashboard header with stats
- [ ] Menu items (Facebook style)
- [ ] Quick action FAB
- [ ] Analytics cards

### Phase 5: Polish
- [ ] Shadows and elevation
- [ ] Hover states
- [ ] Loading states
- [ ] Animations
- [ ] Dark mode considerations (future)

---

## 🎯 Key Differentiators

**mBuy vs Generic Apps:**
1. **Signature Purple**: #7B2CF5 everywhere (not generic blue)
2. **Cairo Font**: Arabic-first typography
3. **Soft Shadows**: Minimal 0.04-0.08 alpha
4. **Round Corners**: 16px cards, 12px inputs
5. **Meta AI Inspiration**: Clean, spacious, modern
6. **Gradient Touches**: Purple gradient on CTAs and active states
7. **Number Emphasis**: Bold weights for stats/prices

---

## 🚀 Export Ready

This design system is ready for:
- **Figma**: Create component library with variants
- **Flutter**: Token values provided for theme
- **CSS**: CSS variables included
- **Documentation**: Ready for dev handoff

---

**Design System Version**: 1.0  
**Last Updated**: December 2025  
**Designed for**: mBuy Shopping Platform  
**Style Reference**: Meta AI × mBuy Purple Identity
