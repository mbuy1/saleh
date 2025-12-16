SELECT p.id, p.name, p.store_id, p.is_active, p.created_at, p.main_image_url 
FROM products p 
ORDER BY p.created_at DESC 
LIMIT 10;
