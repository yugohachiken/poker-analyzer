# Poker Hand Analyzer & Range Chart Platform

A web app for uploading tournament/SNG poker hand histories, building fully
configurable range charts (opening, folding, 3-bet, 4-bet+, push/fold), and
seeing how your actual play compares to those charts — with equity, ICM, and
player-read context along the way.

Built entirely on free tiers: Next.js on Vercel, Postgres/auth via Supabase,
development in GitHub Codespaces.

**Scope note:** this project currently targets tournament/SNG play only.
Blind levels increase over time, antes kick in at higher levels, the table
shrinks as players bust, and there's a payout structure at the end — the
parser, position logic, and push/fold math all assume that structure. Cash
games are out of scope for now.

## Stack

| Layer | Choice |
|---|---|
| Frontend + backend | Next.js (App Router, TypeScript) |
| Styling | Tailwind CSS |
| Database + Auth | Supabase (Postgres + auth + RLS) |
| Hosting | Vercel |
| Dev environment | GitHub Codespaces |
| Equity calculator | Custom TypeScript library (Monte Carlo + exact heads-up) |

## Getting started

```bash
npm install
cp .env.local.example .env.local   # then fill in your Supabase project values
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Project structure

```
/app             route handlers + pages (App Router)
/components      shared React components (e.g. the range grid)
/lib             general utilities
/lib/poker       poker domain logic — cards, equity, ranges, push/fold, ICM,
                 hand parsing, analysis (framework-agnostic, unit-tested)
/lib/supabase    Supabase client setup
/types           shared TypeScript types
```

## Status

Early scaffold — see the build roadmap for the phased plan (schema, poker
math library, range builder UI, push/fold + ICM engine, hand history parser,
analysis engine, bankroll tracking, player notes, deploy polish).
