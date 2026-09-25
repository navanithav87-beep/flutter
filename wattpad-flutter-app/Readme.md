Wattpad-Inspired Flutter Application

A Flutter-based storytelling application prototype designed to demonstrate modern mobile UI development, user navigation and interactive content experiences using Dart and Flutter.

Overview

This project implements a clean, mobile-oriented reading platform interface inspired by contemporary storytelling applications. It includes an authentication flow, personalized home screen, story discovery, library and user profile sections.

The project focuses on building a structured and interactive frontend experience while providing a foundation for future backend and authentication integration.

Key Features
Authentication
Login interface with email and password
Password visibility control
Google sign-in interface
Registration navigation
Home
Personalized user greeting
Recommended stories
Trending stories
Story cards and interactive content
Search and notification actions
Discover
Story exploration interface
Content discovery navigation
Library
Dedicated library interface
Reading-content navigation
Profile
User profile section
Profile editing interface
Logout functionality
Navigation
Bottom navigation architecture
Home, Discover, Library and Profile sections
Interactive screen transitions
Technology Stack
Flutter — Cross-platform UI framework
Dart — Application development language
Material Design — UI components and design system
DartPad — Initial development and prototyping environment
Application Architecture
Authentication
      │
      ▼
    Home
      │
      ├── Discover
      ├── Library
      └── Profile
             │
             ├── Edit Profile
             └── Logout
Project Structure
wattpad_flutter_app/
│
├── main.dart
├── README.md
│
└── assets/
    ├── login.png
    ├── home.png
    └── profile.png
Getting Started
Prerequisites
Flutter SDK
Dart SDK
Visual Studio Code or Android Studio
Chrome, Android Emulator or a physical Android device
Run Locally

Clone the repository:

git clone https://github.com/navanithav87-beep/flutter.git

Navigate to the application:

cd flutter/wattpad_flutter_app

Install dependencies:

flutter pub get

Run the application:

flutter run

To run in Chrome:

flutter run -d chrome
Current Status

Version: 1.0 — UI Prototype

The current implementation focuses on the frontend interface, application navigation and user interaction. Backend authentication, persistent data storage and dynamic content services are not included in the current version.

Future Development

Planned enhancements include:

Firebase authentication
User registration and account management
Story creation and publishing
Persistent library and bookmarks
Search and content filtering
Reading progress tracking
Backend/API integration
Cloud database integration
Personalized content recommendations
Dark mode
User interaction and commenting features
Screenshots
Login

Home

Profile

Learning Objectives

This project demonstrates practical experience with:

Flutter application development
Dart programming
Widget-based UI development
Stateful and stateless widgets
Screen navigation
Form and input interfaces
Interactive UI components
Responsive layout design
Mobile application structure
Author

Navanitha V
B.Tech Artificial Intelligence and Data Science

Areas of Interest: Flutter Development · Python · AI/ML · Generative AI
