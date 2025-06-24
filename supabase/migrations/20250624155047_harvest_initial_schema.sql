
-- Harvest Dating App Database Schema
-- This file contains the complete database schema for the Harvest dating app

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create custom types
CREATE TYPE message_type AS ENUM ('text', 'image', 'gif', 'system');
CREATE TYPE gender_type AS ENUM ('man', 'woman', 'non-binary', 'other');
CREATE TYPE preference_type AS ENUM ('men', 'women', 'everyone');

-- Users table (extends auth.users)
CREATE TABLE users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    nickname TEXT NOT NULL,
    birth_date DATE NOT NULL,
    pronouns TEXT,
    gender gender_type NOT NULL,
    preference preference_type NOT NULL,
    relationship_goals TEXT NOT NULL,
    hobbies TEXT[] DEFAULT '{}',
    bio TEXT,
    photo_urls TEXT[] DEFAULT '{}',
    
    -- Location data
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    city TEXT,
    state TEXT,
    country TEXT,
    
    -- Status fields
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT nickname_length CHECK (char_length(nickname) >= 2 AND char_length(nickname) <= 50),
    CONSTRAINT bio_length CHECK (char_length(bio) <= 500),
    CONSTRAINT valid_age CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years')
);

-- User preferences table
CREATE TABLE user_preferences (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    min_age INTEGER DEFAULT 18,
    max_age INTEGER DEFAULT 99,
    max_distance INTEGER DEFAULT 50, -- in kilometers
    interested_in preference_type NOT NULL,
    show_me TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT valid_age_range CHECK (min_age >= 18 AND max_age <= 99 AND min_age <= max_age),
    CONSTRAINT valid_distance CHECK (max_distance > 0 AND max_distance <= 500)
);

-- Swipes table
CREATE TABLE swipes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    swiper_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    swiped_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    is_like BOOLEAN NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Prevent duplicate swipes
    UNIQUE(swiper_id, swiped_user_id),
    -- Prevent self-swiping
    CONSTRAINT no_self_swipe CHECK (swiper_id != swiped_user_id)
);

-- Matches table
CREATE TABLE matches (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user1_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    user2_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_message_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Ensure user1_id < user2_id for consistency
    CONSTRAINT ordered_users CHECK (user1_id < user2_id),
    -- Prevent duplicate matches
    UNIQUE(user1_id, user2_id)
);

-- Messages table
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    match_id UUID REFERENCES matches(id) ON DELETE CASCADE NOT NULL,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    message_type message_type DEFAULT 'text',
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT content_not_empty CHECK (char_length(trim(content)) > 0),
    CONSTRAINT content_length CHECK (char_length(content) <= 1000)
);

-- Reports table (for user safety)
CREATE TABLE reports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    reporter_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    reported_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    reason TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE,
    
    CONSTRAINT no_self_report CHECK (reporter_id != reported_user_id)
);

-- Blocks table
CREATE TABLE blocks (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    blocker_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    blocked_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(blocker_id, blocked_user_id),
    CONSTRAINT no_self_block CHECK (blocker_id != blocked_user_id)
);

-- Create indexes for performance
CREATE INDEX idx_users_location ON users USING GIST (ST_Point(longitude, latitude));
CREATE INDEX idx_users_active ON users (is_active, last_seen);
CREATE INDEX idx_users_age ON users (birth_date);
CREATE INDEX idx_swipes_swiper ON swipes (swiper_id, created_at);
CREATE INDEX idx_swipes_swiped ON swipes (swiped_user_id);
CREATE INDEX idx_matches_users ON matches (user1_id, user2_id);
CREATE INDEX idx_matches_active ON matches (is_active, last_message_at);
CREATE INDEX idx_messages_match ON messages (match_id, created_at);
CREATE INDEX idx_messages_unread ON messages (match_id, is_read, created_at);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view active profiles" ON users
    FOR SELECT USING (is_active = true);

CREATE POLICY "Users can insert their own profile" ON users
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- User preferences policies
CREATE POLICY "Users can manage their own preferences" ON user_preferences
    FOR ALL USING (auth.uid() = user_id);

-- Swipes policies
CREATE POLICY "Users can view their own swipes" ON swipes
    FOR SELECT USING (auth.uid() = swiper_id);

CREATE POLICY "Users can create their own swipes" ON swipes
    FOR INSERT WITH CHECK (auth.uid() = swiper_id);

-- Matches policies
CREATE POLICY "Users can view their own matches" ON matches
    FOR SELECT USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Messages policies
CREATE POLICY "Users can view messages in their matches" ON messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM matches 
            WHERE matches.id = messages.match_id 
            AND (matches.user1_id = auth.uid() OR matches.user2_id = auth.uid())
        )
    );

CREATE POLICY "Users can send messages in their matches" ON messages
    FOR INSERT WITH CHECK (
        auth.uid() = sender_id AND
        EXISTS (
            SELECT 1 FROM matches 
            WHERE matches.id = messages.match_id 
            AND (matches.user1_id = auth.uid() OR matches.user2_id = auth.uid())
        )
    );

CREATE POLICY "Users can update their own messages" ON messages
    FOR UPDATE USING (auth.uid() = sender_id);

-- Reports policies
CREATE POLICY "Users can create reports" ON reports
    FOR INSERT WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Users can view their own reports" ON reports
    FOR SELECT USING (auth.uid() = reporter_id);

-- Blocks policies
CREATE POLICY "Users can manage their own blocks" ON blocks
    FOR ALL USING (auth.uid() = blocker_id);

-- Functions and triggers

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON user_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create a match when mutual like occurs
CREATE OR REPLACE FUNCTION check_for_match()
RETURNS TRIGGER AS $$
BEGIN
    -- Only proceed if this is a like
    IF NEW.is_like = true THEN
        -- Check if the other user has also liked this user
        IF EXISTS (
            SELECT 1 FROM swipes 
            WHERE swiper_id = NEW.swiped_user_id 
            AND swiped_user_id = NEW.swiper_id 
            AND is_like = true
        ) THEN
            -- Create a match (ensure user1_id < user2_id)
            INSERT INTO matches (user1_id, user2_id)
            VALUES (
                LEAST(NEW.swiper_id, NEW.swiped_user_id),
                GREATEST(NEW.swiper_id, NEW.swiped_user_id)
            )
            ON CONFLICT (user1_id, user2_id) DO NOTHING;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to check for matches after swipe
CREATE TRIGGER check_match_after_swipe
    AFTER INSERT ON swipes
    FOR EACH ROW EXECUTE FUNCTION check_for_match();

-- Function to update last_message_at in matches
CREATE OR REPLACE FUNCTION update_match_last_message()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE matches 
    SET last_message_at = NEW.created_at
    WHERE id = NEW.match_id;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to update match timestamp when message is sent
CREATE TRIGGER update_match_timestamp
    AFTER INSERT ON messages
    FOR EACH ROW EXECUTE FUNCTION update_match_last_message();

-- Set up Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE matches;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;

-- Storage buckets
INSERT INTO storage.buckets (id, name, public) 
VALUES ('profile-photos', 'profile-photos', true);

-- Storage policies
CREATE POLICY "Profile photos are publicly accessible" ON storage.objects
    FOR SELECT USING (bucket_id = 'profile-photos');

CREATE POLICY "Users can upload their own profile photos" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'profile-photos' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can update their own profile photos" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'profile-photos' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete their own profile photos" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'profile-photos' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );