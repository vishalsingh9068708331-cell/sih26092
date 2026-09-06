-- SakshamMatch Database Schema
-- SIH26092: AI-Driven Scheme Matching for Marginalized Entrepreneurs

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table 1: users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table 2: profiles
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    age INTEGER NOT NULL,
    gender VARCHAR(20) NOT NULL,
    category VARCHAR(20) NOT NULL,
    state VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    rural_urban VARCHAR(20) NOT NULL,
    monthly_income DECIMAL(15,2) NOT NULL,
    family_income DECIMAL(15,2) NOT NULL,
    business_type VARCHAR(50) NOT NULL,
    business_stage VARCHAR(50) NOT NULL,
    education TEXT,
    skills TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- Table 3: schemes
CREATE TABLE schemes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    ministry VARCHAR(255) NOT NULL,
    description TEXT,
    benefits TEXT,
    benefit_amount DECIMAL(15,2),
    eligibility_rules JSONB NOT NULL,
    documents_required JSONB NOT NULL,
    application_link VARCHAR(500),
    source_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    scraped_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: applications
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    scheme_id UUID NOT NULL REFERENCES schemes(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'Not Applied',
    applied_at TIMESTAMP WITH TIME ZONE,
    approved_at TIMESTAMP WITH TIME ZONE,
    documents_submitted JSONB,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 5: facilitators
CREATE TABLE facilitators (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    organization VARCHAR(255),
    csc_id VARCHAR(100),
    state VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 6: facilitator_beneficiaries
CREATE TABLE facilitator_beneficiaries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    facilitator_id UUID NOT NULL REFERENCES facilitators(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Active'
);

-- Table 7: analytics
CREATE TABLE analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    date DATE NOT NULL,
    total_users INTEGER DEFAULT 0,
    new_users INTEGER DEFAULT 0,
    total_applications INTEGER DEFAULT 0,
    approved_applications INTEGER DEFAULT 0,
    top_scheme_id UUID REFERENCES schemes(id),
    district VARCHAR(100),
    category VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_category ON profiles(category);
CREATE INDEX idx_profiles_district ON profiles(district);
CREATE INDEX idx_schemes_ministry ON schemes(ministry);
CREATE INDEX idx_schemes_active ON schemes(is_active);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_applications_scheme_id ON applications(scheme_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_facilitator_beneficiaries_facilitator ON facilitator_beneficiaries(facilitator_id);
CREATE INDEX idx_facilitator_beneficiaries_user ON facilitator_beneficiaries(user_id);
CREATE INDEX idx_analytics_date ON analytics(date);
CREATE INDEX idx_analytics_district ON analytics(district);

-- Insert sample data (optional)
-- INSERT INTO users (email, password_hash) VALUES ('test@example.com', 'hashed_password_here');

COMMENT ON TABLE users IS 'User accounts for authentication';
COMMENT ON TABLE profiles IS 'Entrepreneur profiles with demographic and business details';
COMMENT ON TABLE schemes IS 'Government schemes scraped from various portals';
COMMENT ON TABLE applications IS 'Track user applications to schemes';
COMMENT ON TABLE facilitators IS 'CSC operators and NGO workers';
COMMENT ON TABLE facilitator_beneficiaries IS 'Link facilitators to beneficiaries they assist';
COMMENT ON TABLE analytics IS 'Aggregated analytics for MoSJE dashboard';
