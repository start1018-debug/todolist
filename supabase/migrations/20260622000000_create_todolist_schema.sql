CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT users_email_key UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.todos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT todos_user_id_fkey
        FOREIGN KEY (user_id)
        REFERENCES public.users(id)
        ON DELETE CASCADE,
    CONSTRAINT todos_title_not_blank
        CHECK (LENGTH(BTRIM(title)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_users_email
    ON public.users (email);

CREATE INDEX IF NOT EXISTS idx_todos_user_id
    ON public.todos (user_id);

CREATE INDEX IF NOT EXISTS idx_todos_user_id_created_at
    ON public.todos (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_todos_user_id_completed
    ON public.todos (user_id, completed);
