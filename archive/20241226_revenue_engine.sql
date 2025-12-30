-- =====================================================
-- Revenue Engine Database Schema
-- نظام التسعير والمشاريع
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- Templates Table
-- =====================================================
CREATE TABLE IF NOT EXISTS revenue_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_type TEXT NOT NULL CHECK (project_type IN ('ugc_video', 'motion_graphics', 'brand_identity', 'full_campaign')),
  name TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  description TEXT,
  description_ar TEXT,
  thumbnail_url TEXT,
  demo_url TEXT,
  base_price_sar INTEGER NOT NULL DEFAULT 0,
  supported_durations TEXT[] DEFAULT ARRAY['15', '30', '60'],
  supported_qualities TEXT[] DEFAULT ARRAY['standard', 'high', 'ultra'],
  default_steps JSONB NOT NULL DEFAULT '[]',
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- Projects Table
-- =====================================================
CREATE TABLE IF NOT EXISTS revenue_projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  project_type TEXT NOT NULL CHECK (project_type IN ('ugc_video', 'motion_graphics', 'brand_identity', 'full_campaign')),
  template_id UUID REFERENCES revenue_templates(id),
  duration TEXT CHECK (duration IN ('15', '30', '60')),
  quality TEXT NOT NULL CHECK (quality IN ('standard', 'high', 'ultra')),
  voice_type TEXT NOT NULL CHECK (voice_type IN ('none', 'ai_arabic', 'ai_english', 'human_arabic', 'human_english')),
  revision_policy TEXT NOT NULL CHECK (revision_policy IN ('basic', 'standard', 'professional', 'unlimited')),
  extras TEXT[] DEFAULT ARRAY[]::TEXT[],
  
  -- Pricing snapshot (frozen at creation)
  pricing_snapshot JSONB NOT NULL,
  
  -- Status & Progress
  status TEXT NOT NULL DEFAULT 'pending_payment' CHECK (status IN ('draft', 'pending_payment', 'paid', 'in_progress', 'review', 'revision', 'approved', 'locked', 'completed')),
  current_step_index INTEGER DEFAULT 0,
  steps JSONB NOT NULL DEFAULT '[]',
  
  -- Revision tracking
  revisions_used INTEGER DEFAULT 0,
  total_generations INTEGER DEFAULT 0,
  
  -- Locking
  is_locked BOOLEAN DEFAULT false,
  locked_at TIMESTAMPTZ,
  locked_reason TEXT,
  
  -- Output
  output_url TEXT,
  output_files TEXT[] DEFAULT ARRAY[]::TEXT[],
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  paid_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

-- =====================================================
-- Indexes
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_revenue_projects_user_id ON revenue_projects(user_id);
CREATE INDEX IF NOT EXISTS idx_revenue_projects_store_id ON revenue_projects(store_id);
CREATE INDEX IF NOT EXISTS idx_revenue_projects_status ON revenue_projects(status);
CREATE INDEX IF NOT EXISTS idx_revenue_projects_type ON revenue_projects(project_type);
CREATE INDEX IF NOT EXISTS idx_revenue_templates_type ON revenue_templates(project_type);
CREATE INDEX IF NOT EXISTS idx_revenue_templates_active ON revenue_templates(is_active);

-- =====================================================
-- Updated At Trigger
-- =====================================================
CREATE OR REPLACE FUNCTION update_revenue_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_revenue_projects_updated_at
  BEFORE UPDATE ON revenue_projects
  FOR EACH ROW
  EXECUTE FUNCTION update_revenue_updated_at();

CREATE TRIGGER trigger_revenue_templates_updated_at
  BEFORE UPDATE ON revenue_templates
  FOR EACH ROW
  EXECUTE FUNCTION update_revenue_updated_at();

-- =====================================================
-- RLS Policies
-- =====================================================
ALTER TABLE revenue_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE revenue_templates ENABLE ROW LEVEL SECURITY;

-- Templates: Everyone can read active templates
CREATE POLICY "Templates are viewable by everyone" ON revenue_templates
  FOR SELECT USING (is_active = true);

-- Projects: Users can only see their own projects
CREATE POLICY "Users can view own projects" ON revenue_projects
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own projects" ON revenue_projects
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects" ON revenue_projects
  FOR UPDATE USING (auth.uid() = user_id AND is_locked = false);

-- =====================================================
-- Sample Templates
-- =====================================================
INSERT INTO revenue_templates (project_type, name, name_ar, description, description_ar, base_price_sar, sort_order) VALUES
-- UGC Video Templates
('ugc_video', 'Product Review', 'مراجعة منتج', 'Professional product review video', 'فيديو مراجعة منتج احترافي', 299, 1),
('ugc_video', 'Unboxing Experience', 'تجربة فتح المنتج', 'Exciting unboxing video', 'فيديو فتح منتج مثير', 299, 2),
('ugc_video', 'Tutorial/How-To', 'شرح وتعليم', 'Educational product tutorial', 'فيديو تعليمي للمنتج', 349, 3),

-- Motion Graphics Templates
('motion_graphics', 'Logo Animation', 'تحريك الشعار', 'Animated logo intro', 'مقدمة شعار متحركة', 399, 1),
('motion_graphics', 'Explainer Video', 'فيديو توضيحي', 'Animated explainer video', 'فيديو توضيحي متحرك', 499, 2),
('motion_graphics', 'Social Media Ad', 'إعلان سوشيال ميديا', 'Animated social media advertisement', 'إعلان متحرك لوسائل التواصل', 399, 3),

-- Brand Identity Templates
('brand_identity', 'Startup Package', 'باقة الشركات الناشئة', 'Essential brand identity for startups', 'هوية تجارية أساسية للشركات الناشئة', 799, 1),
('brand_identity', 'Business Package', 'باقة الأعمال', 'Complete brand identity package', 'حزمة هوية تجارية متكاملة', 1299, 2),
('brand_identity', 'Premium Package', 'الباقة المميزة', 'Premium brand identity with extended assets', 'هوية تجارية مميزة مع أصول إضافية', 1999, 3),

-- Full Campaign Templates
('full_campaign', 'Product Launch', 'إطلاق منتج', 'Complete product launch campaign', 'حملة إطلاق منتج متكاملة', 1499, 1),
('full_campaign', 'Brand Awareness', 'التوعية بالعلامة', 'Brand awareness campaign', 'حملة توعية بالعلامة التجارية', 1999, 2),
('full_campaign', 'Seasonal Promotion', 'عروض موسمية', 'Seasonal promotional campaign', 'حملة ترويجية موسمية', 2499, 3)
ON CONFLICT DO NOTHING;

-- =====================================================
-- Grant Service Role Access
-- =====================================================
GRANT ALL ON revenue_projects TO service_role;
GRANT ALL ON revenue_templates TO service_role;
