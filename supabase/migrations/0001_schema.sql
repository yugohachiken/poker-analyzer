-- Phase 1: core schema for the poker hand analyzer (tournament/SNG only).

-- ── Enums ────────────────────────────────────────────────────────────────

create type range_type as enum (
  'open_raise',
  'fold_vs_open',
  'three_bet',
  'four_bet_plus',
  'push',
  'call_vs_push'
);

-- Superset of 6-max and 9-max positions. A 6-max range just won't use
-- utg1/utg2/lojack.
create type table_position as enum (
  'utg',
  'utg1',
  'utg2',
  'lojack',
  'hijack',
  'cutoff',
  'button',
  'small_blind',
  'big_blind'
);

create type hand_street as enum ('preflop', 'flop', 'turn', 'river');

create type hand_action_type as enum (
  'fold',
  'check',
  'call',
  'bet',
  'raise',
  'all_in',
  'post_sb',
  'post_bb',
  'post_ante'
);

-- ── Tables ───────────────────────────────────────────────────────────────

create table ranges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  type range_type not null,
  position table_position not null,
  -- The position whose action this range responds to. Null for
  -- open_raise/push (nothing to respond to); required for
  -- fold_vs_open/three_bet/four_bet_plus/call_vs_push.
  vs_position table_position,
  stack_bb_min numeric not null,
  stack_bb_max numeric not null,
  num_opponents integer not null default 1,
  -- 169 canonical starting hands (e.g. "AKs", "77") mapped to
  -- { action: string, frequency: number (0-1) }.
  grid jsonb not null default '{}'::jsonb,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  constraint vs_position_required_check check (
    (type in ('open_raise', 'push') and vs_position is null)
    or (type in ('fold_vs_open', 'three_bet', 'four_bet_plus', 'call_vs_push') and vs_position is not null)
  ),
  constraint stack_range_check check (stack_bb_min <= stack_bb_max)
);

create index ranges_user_id_idx on ranges (user_id);
create index ranges_is_public_idx on ranges (is_public) where is_public = true;

create table hands (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  raw_text text not null,
  parsed_json jsonb,
  game_type text,
  stakes text,
  created_at timestamptz not null default now()
);

create index hands_user_id_idx on hands (user_id);

create table hand_actions (
  id uuid primary key default gen_random_uuid(),
  hand_id uuid not null references hands (id) on delete cascade,
  street hand_street not null,
  position table_position not null,
  action hand_action_type not null,
  amount numeric,
  pot_bb numeric,
  sequence_order integer not null
);

create index hand_actions_hand_id_idx on hand_actions (hand_id);
create index hand_actions_hand_id_sequence_idx on hand_actions (hand_id, sequence_order);

create table analysis_results (
  id uuid primary key default gen_random_uuid(),
  hand_id uuid not null references hands (id) on delete cascade,
  street hand_street not null,
  deviation_from_range numeric,
  equity_at_decision numeric,
  notes text,
  created_at timestamptz not null default now()
);

create index analysis_results_hand_id_idx on analysis_results (hand_id);

create table player_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  player_alias text not null,
  read_tags jsonb not null default '[]'::jsonb,
  free_text text,
  created_at timestamptz not null default now()
);

create index player_notes_user_id_idx on player_notes (user_id);
create unique index player_notes_user_alias_unique on player_notes (user_id, player_alias);
