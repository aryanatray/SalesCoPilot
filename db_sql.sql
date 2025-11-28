-- Create schema
CREATE SCHEMA IF NOT EXISTS sales_schema AUTHORIZATION sales;

-- chat_sessions
CREATE TABLE sales_schema.chat_sessions (
    session_id uuid NOT NULL,
    user_email text NOT NULL,
    title text NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT chat_sessions_pkey PRIMARY KEY (session_id)
);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_updated_at
    ON sales_schema.chat_sessions USING btree (updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_email
    ON sales_schema.chat_sessions USING btree (user_email);

-- chat_interactions
CREATE TABLE sales_schema.chat_interactions (
    session_id uuid NOT NULL,
    query_id uuid NOT NULL,
    user_query text NOT NULL,
    response text NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    feedback text NULL,
    "comment" text NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT chat_interactions_pkey PRIMARY KEY (session_id, query_id)
);

-- chat_logs
CREATE TABLE sales_schema.chat_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_query text NOT NULL,
    bot_response text NOT NULL,
    "timestamp" timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
    username text NULL,
    email text NULL,
    CONSTRAINT chat_logs_pkey PRIMARY KEY (id)
);

-- chat_messages
CREATE TABLE sales_schema.chat_messages (
    id bigserial NOT NULL,
    session_id uuid NOT NULL,
    "role" text NOT NULL,
    "content" text NOT NULL,
    query_id uuid NULL,
    token_count int4 NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
    CONSTRAINT chat_messages_role_check CHECK (
        role = ANY (ARRAY['user'::text, 'assistant'::text, 'system'::text])
    )
);
CREATE INDEX IF NOT EXISTS idx_chat_messages_session_created
    ON sales_schema.chat_messages USING btree (session_id, created_at);

-- Foreign Key: chat_messages -> chat_sessions
ALTER TABLE sales_schema.chat_messages
    ADD CONSTRAINT chat_messages_session_id_fkey
    FOREIGN KEY (session_id)
    REFERENCES sales_schema.chat_sessions(session_id)
    ON DELETE CASCADE;

-- conversation_history
CREATE TABLE sales_schema.conversation_history (
    session_id uuid NOT NULL,
    email varchar(255) NOT NULL,
    user_name varchar(100) NULL,
    conversation jsonb NOT NULL,
    title text NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT conversation_history_pkey PRIMARY KEY (session_id)
);
CREATE INDEX IF NOT EXISTS idx_email
    ON sales_schema.conversation_history USING btree (email);
CREATE INDEX IF NOT EXISTS idx_updated_at
    ON sales_schema.conversation_history USING btree (updated_at DESC);

-- Make sure the function exists; if not, create a dummy version.
-- CREATE OR REPLACE FUNCTION sales_schema.update_updated_at_column() RETURNS trigger AS $$
-- BEGIN
--   NEW.updated_at = now();
--   RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_update_updated_at
    BEFORE UPDATE ON sales_schema.conversation_history
    FOR EACH ROW EXECUTE FUNCTION sales_schema.update_updated_at_column();

-- sharepoint_delta_checkpoints
CREATE TABLE sales_schema.sharepoint_delta_checkpoints (
    last_synced_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    site_id text NOT NULL,
    drive_id text NOT NULL,
    delta_link text NULL,
    CONSTRAINT sharepoint_delta_checkpoints_new_pkey PRIMARY KEY (last_synced_at)
);
