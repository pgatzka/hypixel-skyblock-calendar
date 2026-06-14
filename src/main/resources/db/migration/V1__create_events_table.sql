create table events (
    id               uuid        primary key,
    title            text        not null,
    description      text,
    category         text,
    start_time       timestamptz not null,
    duration_minutes integer     not null,
    recurrence_rule  text,
    created_at       timestamptz not null,
    updated_at       timestamptz not null
);
