-- Add extra_data column to products table to store flexible customization fields
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS extra_data JSONB DEFAULT '{}'::jsonb;

-- Comment on column
COMMENT ON COLUMN products.extra_data IS 'Stores optional customization fields like variants, shipping details, etc.';
