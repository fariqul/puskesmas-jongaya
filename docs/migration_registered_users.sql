-- ================================================
-- MACCA - SQL Migration: Registrasi Pasien
-- Jalankan di Supabase SQL Editor
-- ================================================

-- 1. Buat tabel registered_users
CREATE TABLE IF NOT EXISTS registered_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nama text NOT NULL,
  umur integer NOT NULL,
  no_hp text NOT NULL UNIQUE,  -- NO HP HARUS UNIK
  is_online boolean DEFAULT false,
  last_seen timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

-- 2. Aktifkan Row Level Security
ALTER TABLE registered_users ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies - Public access untuk user
CREATE POLICY "Allow public insert" ON registered_users
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Allow public update" ON registered_users
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "Allow public select" ON registered_users
  FOR SELECT TO anon USING (true);

-- 4. Authenticated users (admin) full access
CREATE POLICY "Allow authenticated full access" ON registered_users
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 5. Tambah kolom registered_user_id di tabel pendaftaran
ALTER TABLE pendaftaran ADD COLUMN IF NOT EXISTS registered_user_id uuid REFERENCES registered_users(id);

-- 6. Index untuk performa query
CREATE INDEX IF NOT EXISTS idx_registered_users_no_hp ON registered_users(no_hp);
CREATE INDEX IF NOT EXISTS idx_registered_users_is_online ON registered_users(is_online);
CREATE INDEX IF NOT EXISTS idx_registered_users_last_seen ON registered_users(last_seen);
