-- ============================================
-- Migration: إضافة الأعمدة المفقودة للجداول الموجودة
-- التاريخ: 2025-01-01
-- ============================================

-- ============================================
-- إضافة الأعمدة المفقودة لجدول stories
-- ============================================
DO $$ 
BEGIN
  -- إضافة عمود product_id إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'product_id') THEN
    ALTER TABLE stories ADD COLUMN product_id UUID REFERENCES products(id) ON DELETE SET NULL;
  END IF;

  -- إضافة عمود type إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'type') THEN
    ALTER TABLE stories ADD COLUMN type TEXT NOT NULL DEFAULT 'video';
  END IF;

  -- إضافة عمود media_url إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'media_url') THEN
    ALTER TABLE stories ADD COLUMN media_url TEXT;
  END IF;

  -- إضافة عمود thumbnail_url إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'thumbnail_url') THEN
    ALTER TABLE stories ADD COLUMN thumbnail_url TEXT;
  END IF;

  -- إضافة عمود caption إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'caption') THEN
    ALTER TABLE stories ADD COLUMN caption TEXT;
  END IF;

  -- إضافة عمود is_active إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'is_active') THEN
    ALTER TABLE stories ADD COLUMN is_active BOOLEAN DEFAULT true;
  END IF;

  -- إضافة عمود views_count إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'views_count') THEN
    ALTER TABLE stories ADD COLUMN views_count INTEGER DEFAULT 0;
  END IF;

  -- إضافة عمود likes_count إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'likes_count') THEN
    ALTER TABLE stories ADD COLUMN likes_count INTEGER DEFAULT 0;
  END IF;

  -- إضافة عمود comments_count إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'comments_count') THEN
    ALTER TABLE stories ADD COLUMN comments_count INTEGER DEFAULT 0;
  END IF;

  -- إضافة عمود shares_count إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'shares_count') THEN
    ALTER TABLE stories ADD COLUMN shares_count INTEGER DEFAULT 0;
  END IF;

  -- إضافة عمود bookmarks_count إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'bookmarks_count') THEN
    ALTER TABLE stories ADD COLUMN bookmarks_count INTEGER DEFAULT 0;
  END IF;

  -- إضافة عمود updated_at إذا لم يكن موجوداً
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'stories' AND column_name = 'updated_at') THEN
    ALTER TABLE stories ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
  END IF;
END $$;

-- ============================================
-- إنشاء Indexes لجدول stories (إذا لم تكن موجودة)
-- ============================================
DO $$ 
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stories' AND column_name = 'type') THEN
    CREATE INDEX IF NOT EXISTS idx_stories_type ON stories(type);
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stories' AND column_name = 'product_id') THEN
    CREATE INDEX IF NOT EXISTS idx_stories_product_id ON stories(product_id);
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stories' AND column_name = 'is_active') THEN
    CREATE INDEX IF NOT EXISTS idx_stories_is_active ON stories(is_active);
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stories' AND column_name = 'views_count') THEN
    CREATE INDEX IF NOT EXISTS idx_stories_views_count ON stories(views_count);
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stories' AND column_name = 'created_at') THEN
    CREATE INDEX IF NOT EXISTS idx_stories_created_at ON stories(created_at DESC);
  END IF;
END $$;

-- ============================================
-- إنشاء الجداول الأخرى (إذا لم تكن موجودة)
-- ============================================

-- جدول story_views
CREATE TABLE IF NOT EXISTS story_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  story_id UUID REFERENCES stories(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(story_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_story_views_story_id ON story_views(story_id);
CREATE INDEX IF NOT EXISTS idx_story_views_user_id ON story_views(user_id);
CREATE INDEX IF NOT EXISTS idx_story_views_viewed_at ON story_views(viewed_at DESC);

-- جدول story_likes
CREATE TABLE IF NOT EXISTS story_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  story_id UUID REFERENCES stories(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(story_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_story_likes_story_id ON story_likes(story_id);
CREATE INDEX IF NOT EXISTS idx_story_likes_user_id ON story_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_story_likes_created_at ON story_likes(created_at DESC);

-- جدول user_fcm_tokens
CREATE TABLE IF NOT EXISTS user_fcm_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  token TEXT NOT NULL UNIQUE,
  device_type TEXT DEFAULT 'mobile',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_id ON user_fcm_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_token ON user_fcm_tokens(token);

-- ============================================
-- إنشاء Functions
-- ============================================

-- Function: increment_story_views
CREATE OR REPLACE FUNCTION increment_story_views(story_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE stories
  SET views_count = views_count + 1,
      updated_at = NOW()
  WHERE id = story_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: update_story_likes_count
CREATE OR REPLACE FUNCTION update_story_likes_count(story_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE stories
  SET likes_count = (
    SELECT COUNT(*) 
    FROM story_likes 
    WHERE story_likes.story_id = update_story_likes_count.story_id
  ),
  updated_at = NOW()
  WHERE id = story_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- إنشاء Triggers
-- ============================================

-- Function: update_updated_at_column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger لجدول stories
DROP TRIGGER IF EXISTS update_stories_updated_at ON stories;
CREATE TRIGGER update_stories_updated_at
  BEFORE UPDATE ON stories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger لجدول user_fcm_tokens
DROP TRIGGER IF EXISTS update_user_fcm_tokens_updated_at ON user_fcm_tokens;
CREATE TRIGGER update_user_fcm_tokens_updated_at
  BEFORE UPDATE ON user_fcm_tokens
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

