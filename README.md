**Story Club – Flutter App**

A modern storytelling application built using Flutter, following Clean Architecture, BLoC State Management, and Firebase Firestore as backend.
Story Club allows users to write stories, record audio stories, listen, edit, and manage their creative content.

**Features**
**Module 1 – I Am A Story Teller**

Record audio stories

Upload thumbnail images

Choose story genres

Built‑in audio player

Edit & delete stories

Firebase Firestore storage

Cloudinary image upload

Smooth UI & animations

**Module 2 – I Am A Story Writer**
Write full stories

Add cover image

Story description + full content

Story Types:

Short Film

Featured Film

Advertisements

30 Seconds Stories

45 Seconds Stories

60 Seconds Stories

Books

Biographies

** Architecture Overview**
Code
lib/
 └── features/
      |-- Auth
      ├── storyteller/
      └── storywriter/
           ├── data/
           │    ├── datasources/
           │    ├── models/
           │    └── repositories/
           ├── domain/
           │    ├── entities/
           │    ├── repositories/
           │    └── usecases/
           └── presentation/
                ├── bloc/
                └── pages/
**Domain Layer**
Entities
Abstract Repositories
Usecases

**Data Layer**
Models
Firestore Remote Data Source
Repository Implementations

**Presentation Layer**
BLoC (Events, States, Bloc)

UI Screens (List, Add, Edit, Details, Types)

 **Tech Stack**
Flutter (Dart)
BLoC State Management
Firebase Firestore
Cloudinary (image upload)
AudioPlayers (for Story Teller module)
Clean Architecture
Responsive UI

 **How to Run the Project**
Clone the repository:

Code
git clone (https://github.com/Priya-Viji/Story_Club_App).git
Install dependencies:

Code
flutter pub get
Run the app:

Code
flutter run
**Setup Requirements**
Firebase Setup
Add your google-services.json file under:

Code
android/app/

**Cloudinary Setup**
Add your Cloudinary credentials inside your Cloudinary service file:
cloud_name
api_key
api_secret

