-- Phase 1: Row Level Security policies.
-- Default posture: a user can only read/write their own rows. The one
-- exception is `ranges` where is_public = true rows are readable by anyone
-- (including anonymous/unauthenticated visitors), since public ranges are
-- meant to be shareable.

alter table ranges enable row level security;
alter table hands enable row level security;
alter table hand_actions enable row level security;
alter table analysis_results enable row level security;
alter table player_notes enable row level security;

-- ── ranges ───────────────────────────────────────────────────────────────

create policy "ranges: select own or public"
  on ranges for select
  using (auth.uid() = user_id or is_public = true);

create policy "ranges: insert own"
  on ranges for insert
  with check (auth.uid() = user_id);

create policy "ranges: update own"
  on ranges for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "ranges: delete own"
  on ranges for delete
  using (auth.uid() = user_id);

-- ── hands ────────────────────────────────────────────────────────────────

create policy "hands: select own"
  on hands for select
  using (auth.uid() = user_id);

create policy "hands: insert own"
  on hands for insert
  with check (auth.uid() = user_id);

create policy "hands: update own"
  on hands for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "hands: delete own"
  on hands for delete
  using (auth.uid() = user_id);

-- ── hand_actions ─────────────────────────────────────────────────────────
-- No direct user_id column; ownership is derived through the parent hand.

create policy "hand_actions: select via parent hand"
  on hand_actions for select
  using (
    exists (
      select 1 from hands
      where hands.id = hand_actions.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "hand_actions: insert via parent hand"
  on hand_actions for insert
  with check (
    exists (
      select 1 from hands
      where hands.id = hand_actions.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "hand_actions: update via parent hand"
  on hand_actions for update
  using (
    exists (
      select 1 from hands
      where hands.id = hand_actions.hand_id
        and hands.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from hands
      where hands.id = hand_actions.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "hand_actions: delete via parent hand"
  on hand_actions for delete
  using (
    exists (
      select 1 from hands
      where hands.id = hand_actions.hand_id
        and hands.user_id = auth.uid()
    )
  );

-- ── analysis_results ─────────────────────────────────────────────────────
-- Same pattern: ownership derived through the parent hand.

create policy "analysis_results: select via parent hand"
  on analysis_results for select
  using (
    exists (
      select 1 from hands
      where hands.id = analysis_results.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "analysis_results: insert via parent hand"
  on analysis_results for insert
  with check (
    exists (
      select 1 from hands
      where hands.id = analysis_results.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "analysis_results: update via parent hand"
  on analysis_results for update
  using (
    exists (
      select 1 from hands
      where hands.id = analysis_results.hand_id
        and hands.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from hands
      where hands.id = analysis_results.hand_id
        and hands.user_id = auth.uid()
    )
  );

create policy "analysis_results: delete via parent hand"
  on analysis_results for delete
  using (
    exists (
      select 1 from hands
      where hands.id = analysis_results.hand_id
        and hands.user_id = auth.uid()
    )
  );

-- ── player_notes ─────────────────────────────────────────────────────────

create policy "player_notes: select own"
  on player_notes for select
  using (auth.uid() = user_id);

create policy "player_notes: insert own"
  on player_notes for insert
  with check (auth.uid() = user_id);

create policy "player_notes: update own"
  on player_notes for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "player_notes: delete own"
  on player_notes for delete
  using (auth.uid() = user_id);
