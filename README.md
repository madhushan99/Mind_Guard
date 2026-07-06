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

