-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. Main Table: mbuy_studio
-- Master table to track all operations/requests.
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.mbuy_studio (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    store_id UUID REFERENCES public.stores(id) ON DELETE SET NULL,
    
    -- Type of generation: 'image', 'video', '3d', etc.
    task_type TEXT NOT NULL CHECK (task_type IN ('image', 'video', '3d', 'voice', 'template')),
    
    -- General status of the operation
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    
    -- External Task ID (e.g., from NanoBanana)
    provider_task_id TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ============================================================================
-- 2. Image Results Table: mbuy_studio_image
-- Stores prompt and result for image generation.
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.mbuy_studio_image (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_id UUID REFERENCES public.mbuy_studio(id) ON DELETE CASCADE NOT NULL,
    
    -- The prompt used for this specific image
    prompt TEXT NOT NULL,
    
    -- The URL of the generated image
    result_url TEXT, -- Can be null initially if processing
    
    -- Metadata
    width INTEGER,
    height INTEGER,
    format TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ============================================================================
-- 3. Video Results Table: mbuy_studio_video
-- Stores prompt and result for video generation.
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.mbuy_studio_video (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_id UUID REFERENCES public.mbuy_studio(id) ON DELETE CASCADE NOT NULL,
    
    -- The prompt used for this specific video
    prompt TEXT NOT NULL,
    
    -- The URL of the generated video
    result_url TEXT,
    
    -- Metadata
    duration_seconds INTEGER,
    thumbnail_url TEXT,
    format TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ============================================================================
-- 4. 3D Results Table: mbuy_studio_3D
-- Stores prompt and result for 3D generation.
-- ============================================================================
CREATE TABLE IF NOT EXISTS public."mbuy_studio_3D" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_id UUID REFERENCES public.mbuy_studio(id) ON DELETE CASCADE NOT NULL,
    
    -- The prompt used for this specific 3D model
    prompt TEXT NOT NULL,
    
    -- The URL of the generated 3D model
    result_url TEXT,
    
    -- Metadata
    format TEXT,
    preview_image_url TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ============================================================================
-- Row Level Security (RLS) Policies
-- ============================================================================

-- Enable RLS
ALTER TABLE public.mbuy_studio ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mbuy_studio_image ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mbuy_studio_video ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."mbuy_studio_3D" ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first (to allow re-running this script)
DROP POLICY IF EXISTS "Users can view their own studio requests" ON public.mbuy_studio;
DROP POLICY IF EXISTS "Users can insert their own studio requests" ON public.mbuy_studio;
DROP POLICY IF EXISTS "Users can update their own studio requests" ON public.mbuy_studio;
DROP POLICY IF EXISTS "Users can view their own images" ON public.mbuy_studio_image;
DROP POLICY IF EXISTS "Users can insert their own images" ON public.mbuy_studio_image;
DROP POLICY IF EXISTS "Users can view their own videos" ON public.mbuy_studio_video;
DROP POLICY IF EXISTS "Users can insert their own videos" ON public.mbuy_studio_video;
DROP POLICY IF EXISTS "Users can view their own 3D models" ON public."mbuy_studio_3D";
DROP POLICY IF EXISTS "Users can insert their own 3D models" ON public."mbuy_studio_3D";

-- Policies for mbuy_studio
CREATE POLICY "Users can view their own studio requests"
    ON public.mbuy_studio FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own studio requests"
    ON public.mbuy_studio FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own studio requests"
    ON public.mbuy_studio FOR UPDATE
    USING (auth.uid() = user_id);

-- Policies for mbuy_studio_image
CREATE POLICY "Users can view their own images"
    ON public.mbuy_studio_image FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = mbuy_studio_image.request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

CREATE POLICY "Users can insert their own images"
    ON public.mbuy_studio_image FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = mbuy_studio_image.request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

-- Policies for mbuy_studio_video
CREATE POLICY "Users can view their own videos"
    ON public.mbuy_studio_video FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = mbuy_studio_video.request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

CREATE POLICY "Users can insert their own videos"
    ON public.mbuy_studio_video FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = mbuy_studio_video.request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

-- Policies for mbuy_studio_3D
CREATE POLICY "Users can view their own 3D models"
    ON public."mbuy_studio_3D" FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = "mbuy_studio_3D".request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

CREATE POLICY "Users can insert their own 3D models"
    ON public."mbuy_studio_3D" FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.mbuy_studio
        WHERE mbuy_studio.id = "mbuy_studio_3D".request_id
        AND mbuy_studio.user_id = auth.uid()
    ));

-- ============================================================================
-- Triggers
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_timestamp_mbuy_studio ON public.mbuy_studio;
CREATE TRIGGER set_timestamp_mbuy_studio
    BEFORE UPDATE ON public.mbuy_studio
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();
