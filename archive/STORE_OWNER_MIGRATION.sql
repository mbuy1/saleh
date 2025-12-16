-- Migration: Add owner_id to stores table and ensure proper relationships
-- Date: December 9, 2025
-- Description: Ensure stores table has proper foreign key relationship with user_profiles

-- Add owner_id column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'stores' AND column_name = 'owner_id') THEN
        ALTER TABLE stores ADD COLUMN owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE;
        CREATE INDEX IF NOT EXISTS idx_stores_owner_id ON stores(owner_id);
        RAISE NOTICE 'Added owner_id column to stores table';
    ELSE
        RAISE NOTICE 'owner_id column already exists in stores table';
    END IF;
END $$;

-- Ensure is_active column exists (for backward compatibility)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'stores' AND column_name = 'is_active') THEN
        ALTER TABLE stores ADD COLUMN is_active BOOLEAN DEFAULT true;
        RAISE NOTICE 'Added is_active column to stores table';
    END IF;
END $$;

-- Update any existing stores without owner_id (if possible)
-- This is a safety measure, but in practice, all stores should have owner_id
UPDATE stores
SET owner_id = (
    SELECT up.id
    FROM user_profiles up
    JOIN mbuy_users mu ON mu.id = up.mbuy_user_id
    WHERE mu.email = stores.email
    LIMIT 1
)
WHERE owner_id IS NULL AND email IS NOT NULL;

-- Log the migration completion
DO $$
BEGIN
    RAISE NOTICE 'Migration completed: stores table relationships ensured';
END $$;