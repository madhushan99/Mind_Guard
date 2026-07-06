# MindGuard 🛡️

*MindGuard* is a mental wellness tracking mobile application built with Flutter and Supabase. It helps users build healthy daily habits, track their mood and stress levels over time, complete simple wellness tasks, and connect with verified clinical professionals when they need extra support.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [OOP Concepts & Design Patterns](#oop-concepts--design-patterns)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Security Notes](#security-notes)
- [Team](#team)
- [Future Work](#future-work)

---

## Overview

Stress builds up quietly — through poor sleep, long work hours, too much screen time, and too little exercise. MindGuard makes it easy to notice these patterns early by turning a daily 30-second check-in into a simple, visual picture of your mental wellness over time.

## Features

- 🔐 *Secure accounts* — email/password sign-up with email verification, powered by Supabase Auth.
- 📝 *Daily habit logging* — log sleep hours, work hours, screen time, and exercise duration each day.
- 😊 *Mood & stress tracking* — record your mood (happy, neutral, stressed, sad) alongside a computed stress score.
- 📊 *History view* — look back at past daily logs to spot trends over time.
- ✅ *Wellness checklist* — simple daily tasks you can add, complete, and track.
- 🩺 *Clinical support directory* — browse verified doctors with their specialties, ratings, and contact details.
- 👤 *Profile management* — edit your name, age, and occupation, synced to your account.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart SDK ^3.6.2) |
| Backend | [Supabase](https://supabase.com) (Postgres, Auth) |
| State/Local | provider, shared_preferences |
| Charts | fl_chart |

Key dependencies (see pubspec.yaml):
- supabase_flutter: ^2.5.6
- fl_chart: ^0.68.0
- provider: ^6.1.2
- shared_preferences: ^2.2.3

## Architecture

MindGuard follows a simple, layered architecture that keeps UI, business logic, and data cleanly separated:


Screens  →  Services  →  Supabase (Postgres + Auth)
   ↑            ↓
   └────── Models ──────┘


- *Models* (lib/models/) — plain Dart classes representing the app's data (users, stress logs, wellness tasks, doctors), each responsible for converting itself to/from the database's map format.
- *Services* (lib/services/) — singleton classes that wrap every Supabase call (auth, data reads/writes) behind a clean API, so screens never talk to Supabase directly.
- *Screens* (lib/screens/) — UI only; they call services and render the result.

## OOP Concepts & Design Patterns

The codebase deliberately applies core OOP principles:

| Concept | Where it's used |
|---|---|
| *Abstraction* | BaseModel is an abstract class defining a shared contract (toMap(), modelType) that every model must implement. |
| *Inheritance* | UserModel, StressLogModel, and WellnessTaskModel all extend BaseModel, reusing its id and createdAt fields. |
| *Polymorphism* | Each subclass overrides toMap() and modelType with its own logic — the same method call behaves differently depending on the object's actual type. |
| *Encapsulation* | UserModel keeps its fields private (_name, _age, etc.) and exposes them only through getters and validated setters (e.g. age must be between 1 and 120). |
| *Custom types (enums)* | The Mood enum (happy, neutral, stressed, sad) replaces raw strings, preventing invalid values at the type level. |
| *Singleton pattern* | AuthService, DataService, and QuestionBank each use a private constructor + factory constructor so the whole app shares one instance and one consistent session state. |

## Database Schema

The Supabase Postgres backend has four tables, all protected by *Row Level Security (RLS)* so a user can only ever read or write their own data:

| Table | Purpose |
|---|---|
| profiles | One row per user — name, age, occupation. Linked 1:1 to auth.users. |
| stress_logs | Daily check-in entries — sleep/work/screen/exercise stats, mood, and stress score. |
| wellness_tasks | User-created wellness checklist items with completion state. |
| doctors | Public read-only directory of clinical professionals. |

All RLS policies check auth.uid() = user_id (or = id for profiles), ensuring the public Supabase anon key alone can never expose another user's data.

## Project Structure


lib/
├── main.dart                     # App entry point, Supabase initialization
├── models/
│   ├── base_model.dart           # Abstract base class (abstraction)
│   ├── user_model.dart           # Encapsulation + validated setters
│   ├── stress_log_model.dart     # Inheritance, polymorphism, Mood enum
│   ├── wellness_task_model.dart  # Inheritance, polymorphism
│   ├── doctor_model.dart
│   └── question_model.dart
├── services/
│   ├── auth_service.dart         # Singleton — auth & profile calls
│   ├── data_service.dart         # Singleton — stress logs & tasks
│   ├── doctor_service.dart       # Doctor directory queries
│   ├── question_bank.dart        # Singleton — question bank data
│   └── supabase_config.dart      # Supabase URL & anon key
├── screens/
│   ├── auth/                     # Splash, login, register, verify email
│   ├── onboarding/                # Profile setup
│   └── home/                     # Home, log data, stress check, history, to-do, clinical support
└── theme/
    └── app_theme.dart


## Getting Started

### Prerequisites
- Flutter SDK (Dart ^3.6.2)
- A Supabase project (free tier is enough)

### Setup

1. Clone the repository and install dependencies:
   bash
   flutter pub get
   
2. Create a Supabase project, then run the schema and RLS SQL scripts to create the profiles, stress_logs, wellness_tasks, and doctors tables.
3. Add your Supabase credentials in lib/services/supabase_config.dart:
   dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   
   > For anything beyond local testing, prefer passing these via --dart-define instead of hardcoding them, so real keys never end up committed to source control.
4. Run the app:
   bash
   flutter run
   

## Security Notes

- Every table has *Row Level Security enabled* — this is non-negotiable. The Supabase anon key is meant to be public; RLS is what actually protects user data.
- Never commit the service_role key anywhere in the Flutter app — only the anon key belongs on the client.
- Email confirmation is enabled on sign-up; users must verify their email before their first login.

## Team

| Name |
|---|
| G.W.P. Madhushan |
| B.S.M.P. Munasinghe |
| P.M.D. Bandara |
| D.M.S.P. Wijesekara |
| D.M.T. De Zoysa |

## Future Work

- AI-assisted stress prediction based on historical daily logs
- Deep-linked email verification that returns straight into the app
- Push notification reminders for daily check-ins
- In-app appointment booking with clinical professionals
