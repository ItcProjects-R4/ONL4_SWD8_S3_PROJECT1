# 🍽️ Recipes App

A modern Flutter application for discovering, searching, and saving cooking recipes from around the world using TheMealDB API and Firebase Authentication.

---

# 📋 Project Overview

## Project Idea

Recipes App is a mobile application that helps users discover cooking recipes, search for meals, save favorite recipes, and follow detailed cooking instructions.

## Problem Statement

Many cooking websites are crowded with advertisements and complex navigation. Users often struggle to find recipes quickly and save their favorite meals in one place.

## Project Goal

To provide a simple and user-friendly platform that allows users to:

* Search for recipes instantly.
* Browse recipes by category.
* Save favorite recipes.
* View detailed ingredients and cooking steps.
* Manage their profile securely.

---

# 🎯 Project Objectives

* Improve user experience for recipe discovery.
* Provide secure authentication using Firebase.
* Enable recipe management through Favorites.
* Offer responsive and attractive UI design.
* Practice Flutter development and software engineering principles.

---

# 👥 Target Users

* Home cooks.
* Cooking enthusiasts.
* Students living alone.
* Anyone looking for easy recipes.

---

# 🛠️ Technology Stack

| Layer           | Technology              |
| --------------- | ----------------------- |
| Frontend        | Flutter                 |
| Language        | Dart                    |
| Authentication  | Firebase Authentication |
| API             | TheMealDB API           |
| Local Storage   | SharedPreferences       |
| Testing         | Flutter Test, Mockito   |
| Version Control | Git & GitHub            |

---

# 📱 Features

### Authentication

* User Registration
* User Login
* Password Reset
* Secure Logout

### Recipe Management

* Search Recipes
* Filter by Categories
* View Recipe Details
* View Ingredients
* View Cooking Steps

### Favorites

* Add Recipe to Favorites
* Remove Recipe from Favorites
* Persistent Favorites Storage

### User Profile

* Display User Information
* Member Since Date
* Weekly App Usage Statistics

---

# 🖥️ Application Screens

| Screen          | Description             |
| --------------- | ----------------------- |
| Onboarding      | Welcome Screens         |
| Login           | User Authentication     |
| Register        | Create New Account      |
| Forgot Password | Reset Password          |
| Home            | Browse Recipes          |
| Favorites       | Saved Recipes           |
| Profile         | User Information        |
| Recipe Details  | Full Recipe Information |

---

# 📂 Project Structure

```text
lib/
│
├── models/
├── screens/
├── services/
├── assets/
├── app_colors.dart
└── main.dart

test/
│
├── unit/
├── widgets/
└── helpers/
```

---

# 🔄 Software Engineering Artifacts

## Functional Requirements

1. User can create an account.
2. User can log into the system.
3. User can search recipes.
4. User can filter recipes by category.
5. User can save favorite recipes.
6. User can view recipe details.
7. User can reset password.
8. User can view profile information.

## Non-Functional Requirements

* Fast response time.
* User-friendly interface.
* Secure authentication.
* Responsive design.
* Reliable data storage.

---

# 📊 Use Cases

* Register Account
* Login
* Search Recipe
* Filter Recipes
* Save Favorite Recipe
* View Recipe Details
* Reset Password
* Logout

---

# 🧪 Testing

## Test Cases

| ID     | Test Case         | Status |
| ------ | ----------------- | ------ |
| TC-001 | Valid Login       | ✅ PASS |
| TC-002 | Invalid Login     | ✅ PASS |
| TC-003 | User Registration | ✅ PASS |
| TC-004 | Search Recipe     | ✅ PASS |
| TC-005 | Add Favorite      | ✅ PASS |
| TC-006 | View Details      | ✅ PASS |
| TC-007 | Logout            | ✅ PASS |

### Testing Types

* Unit Testing
* Widget Testing
* Integration Verification

---

# 🔐 Security

* Firebase Authentication
* Input Validation
* Password Encryption by Firebase
* Protected User Sessions

---

# 📦 Installation

## Prerequisites

* Flutter SDK
* Android Studio
* VS Code
* Git

## Clone Repository

```bash
git clone https://github.com/ItcProjects-R4/ONL4_SWD8_S3_PROJECT1.git
```

```bash
cd ONL4_SWD8_S3_PROJECT1
```

## Install Dependencies

```bash
flutter pub get
```

## Run Application

```bash
flutter run
```

---

# 🚀 Build APK

```bash
flutter build apk --release
```

Generated APK:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# 📄 User Manual

## Create Account

1. Open the application.
2. Click Sign Up.
3. Enter Email and Password.
4. Press Register.

## Login

1. Enter Email.
2. Enter Password.
3. Press Login.

## Search Recipes

1. Use Search Bar.
2. Enter recipe name.
3. Browse results.

## Save Favorites

1. Open a recipe.
2. Tap the Heart Icon.
3. View it later in Favorites.

## View Recipe Details

1. Select a recipe.
2. Read ingredients.
3. Follow cooking instructions.

---

# 📑 Technical Documentation

## Architecture Pattern

MVC (Model - View - Controller)

### Models

* Recipe Model
* Onboarding Model

### Views

* Application Screens

# 📈 Future Enhancements

* Dark/Light Theme
* User Profile Images
* Recipe Ratings
* Offline Mode
* AI Recipe Recommendations

---

 APK - Recipes App v1.0.0(releases/recipes-app-v1.0.0.apk)
---

# 🔗 Repository

GitHub Repository:

https://github.com/ItcProjects-R4/ONL4_SWD8_S3_PROJECT1
