# Wattpad-Inspired Flutter Application

A Flutter-based storytelling application prototype developed to demonstrate
modern mobile UI development, application navigation and interactive content
experiences using Dart and Flutter.

## Overview

This project implements a clean, mobile-oriented reading platform interface
inspired by modern storytelling applications. It includes an authentication
flow, personalized home screen, story discovery, library and user profile
sections.

The application focuses on frontend development and provides a structured
foundation for future integration of authentication services, APIs and
persistent data storage.

## Features

### Authentication

- Email and password login interface
- Password visibility control
- Google sign-in interface
- Registration navigation

### Home

- Personalized user greeting
- Recommended stories
- Trending stories
- Interactive story cards
- Search interface
- Notification access

### Discover

- Story exploration interface
- Content discovery navigation
- Interactive navigation elements

### Library

- Dedicated library section
- Reading-content navigation
- Structured reading experience

### Profile

- User profile section
- Profile editing interface
- Logout functionality

### Navigation

- Bottom navigation architecture
- Home, Discover, Library and Profile sections
- Interactive screen transitions

## Technology Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform application development |
| **Dart** | Application programming language |
| **Material Design** | UI components and design system |
| **DartPad** | Initial development and prototyping |

## Application Architecture

```text
Authentication
      │
      ▼
    Home
      │
      ├── Discover
      │
      ├── Library
      │
      └── Profile
             │
             ├── Edit Profile
             │
             └── Logout
