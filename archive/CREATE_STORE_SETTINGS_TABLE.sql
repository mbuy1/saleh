-- ============================================================================
-- Create store_settings table for Multi-Tenant Store Platform
-- ============================================================================

-- Create store_settings table
CREATE TABLE IF NOT EXISTS store_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  theme_id TEXT DEFAULT 'modern',
  primary_color TEXT DEFAULT '#2563EB',
  secondary_color TEXT DEFAULT '#7C3AED',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(store_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_store_settings_store_id ON store_settings(store_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_store_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
CREATE TRIGGER trigger_update_store_settings_updated_at
  BEFORE UPDATE ON store_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_store_settings_updated_at();

-- Add RLS policies (if needed)
ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read store settings (public)
CREATE POLICY "Store settings are viewable by everyone"
  ON store_settings FOR SELECT
  USING (true);

CREATE POLICY "Store owners can update their settings"
  ON store_settings FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM stores
      WHERE stores.id = store_settings.store_id
      AND stores.owner_id = auth.uid()::uuid
    )
  );

-- Policy: Only store owners can insert settings
CREATE POLICY "Store owners can insert their settings"
  ON store_settings FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM stores
      WHERE stores.id = store_settings.store_id
      AND stores.owner_id = auth.uid()::uuid
    )
  );
