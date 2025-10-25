-- Add is_admin column to auth.users table if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'auth' 
        AND table_name = 'users' 
        AND column_name = 'is_admin'
    ) THEN
        ALTER TABLE auth.users ADD COLUMN is_admin BOOLEAN DEFAULT FALSE;
        
        -- Set up appropriate policies for the is_admin column
        CREATE POLICY "Users can view their own is_admin status" 
        ON auth.users 
        FOR SELECT 
        USING (auth.uid() = id);
        
        CREATE POLICY "Only admins can update is_admin status" 
        ON auth.users 
        FOR UPDATE 
        USING (
            EXISTS (
                SELECT 1 FROM auth.users 
                WHERE id = auth.uid() 
                AND is_admin = TRUE
            )
        );
        
        -- Make sure only admins can see admin user list
        CREATE POLICY "Admins can view all users" 
        ON auth.users 
        FOR SELECT 
        USING (
            EXISTS (
                SELECT 1 FROM auth.users 
                WHERE id = auth.uid() 
                AND is_admin = TRUE
            )
        );
        
        -- Create initial admin user if specified via environment variable
        -- In real deployment, you would have a secure method to set the initial admin
        INSERT INTO auth.users (id, is_admin)
        VALUES ('00000000-0000-0000-0000-000000000000', TRUE)
        ON CONFLICT (id) DO UPDATE
        SET is_admin = TRUE;
    END IF;
END
$$;