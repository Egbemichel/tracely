# Tracely: A Smart Learning Trail Management Application

## 📋 Project Information

**Project Title:** _[Tracely: A Smart Learning Trail Management Application]_

**Student Name:** _[EGBE MICHEL TAMBE]_

**Course:** _[CSC 3410 Introduction to Mobile Application]_

**Institution:** _[THE ICT UNIVERSITY]_

**Date:** 5 January 2026

---

## 📖 Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Solution](#solution)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Firebase Setup](#firebase-setup)
- [API Integration](#api-integration)
- [UI/UX Design](#uiux-design)
- [State Management](#state-management)
- [Data Models](#data-models)
- [Security](#security)
- [Testing](#testing)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**Tracely** is a mobile application designed to help learners organize, track, and revisit their learning resources across the web. Built with Flutter, Tracely addresses the common problem of scattered learning materials by creating organized "trails" that map a user's learning journey.

The application allows users to:
- Search the web for learning resources
- Organize resources into themed trails
- Track time spent on each resource
- Preview content within the app
- Access their learning history anytime

---

## 🔍 Problem Statement

Modern learners face a significant challenge: **learning is scattered**. When researching a topic, users often:

1. Jump between multiple websites, YouTube videos, and PDF documents
2. Lose track of valuable resources they've found
3. Can't remember which sources were most helpful
4. Struggle to revisit their learning path
5. Have no centralized system to organize educational content

This fragmentation leads to:
- Wasted time searching for previously found resources
- Difficulty in building upon previous knowledge
- Lack of structured learning pathways
- Reduced learning efficiency

---

## 💡 Solution

Tracely solves this problem by providing a **unified learning journey tracker** that:

### Core Solution Features:
1. **Trail Creation**: Organize resources into themed learning trails
2. **Web Search Integration**: Search directly within the app using Google Custom Search API
3. **Resource Preview**: View content (websites, PDFs, YouTube videos) without leaving the app
4. **Activity Tracking**: Automatically track time spent on each resource
5. **Cloud Synchronization**: All data synced to Firebase for cross-device access
6. **Beautiful UI**: Intuitive, modern interface following Material Design principles

### User Journey:
```
1. User searches for a topic (e.g., "React Hooks")
2. App displays relevant results from the web
3. User taps a result to preview it
4. User selects/creates a trail to save the resource
5. Resource is saved with metadata (time spent, date, etc.)
6. User can revisit the trail anytime to see all resources
```

---

## ✨ Features

### 🔐 Authentication
- **Email/Password Authentication** via Firebase Auth
- **Google Sign-In** integration
- **Password Reset** functionality
- **Email Verification**
- Secure session management

### 🏠 Home Screen
- **Welcome Header** with personalized greeting
- **Trail Cards** displaying user's learning trails
- **Featured Trail** banner highlighting most recent trail
- **Real-time Resource Counts** from Firestore
- **Quick Navigation** to trail details

### 🔍 Explore (Search)
- **Web Search** powered by Google Custom Search API
- **Multi-source Results**: Websites, YouTube videos, and PDFs
- **Result Cards** with title, description, and source
- **Tap to Preview** any result
- **Smart Categorization** by resource type

### 📱 Resource Preview
- **In-app WebView** for websites
- **YouTube Video Embedding** for video content
- **PDF Viewer** via Google Docs integration
- **Time Tracking** automatically records viewing duration
- **Trail Selection** - choose which trail to save to
- **Create Trail on-the-fly** without leaving preview
- **Metadata Extraction** (title, description, keywords)

### 🗺️ Trail Details
- **Trail Overview** with title, creation date, and stats
- **Resource Timeline** showing all saved resources
- **Chronological Ordering** (most recent first)
- **Resource Cards** with icons for different types
- **Time Spent Display** for each resource
- **Empty State** guidance when no resources exist

### 👤 Profile
- **User Information Display**:
  - Display name / username
  - Email address
  - Account verification status
  - Member since date
- **Statistics Cards**:
  - Total trails count
  - Total resources count
- **Sign Out** with confirmation dialog
- **Beautiful Gradient Header** with avatar

### 🎨 Onboarding
- **Two-page Walkthrough** explaining app value
- **Custom Illustrations** showing problem and solution
- **Skip Functionality** for returning users
- **Smooth Page Transitions** with animations
- **Call-to-Action** buttons for signup

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.7.2
- **Language**: Dart (SDK ^3.7.2)
- **UI Library**: Material Design 3
- **Routing**: go_router (^17.0.0)
- **Animations**: flutter_animate (^4.5.2)
- **Icons**: iconsax_plus (^1.0.0)
- **SVG Support**: flutter_svg (^1.1.6)

### Backend & Services
- **Backend-as-a-Service**: Firebase
  - **Authentication**: firebase_auth (^6.1.3)
  - **Database**: cloud_firestore (^6.1.1)
  - **Core**: firebase_core (^4.3.0)
  - **Push Notifications**: firebase_messaging (^16.1.0)

### Web Technologies
- **WebView**: webview_flutter (^4.13.0)
  - **Android**: webview_flutter_android (^4.10.1)
  - **iOS**: webview_flutter_wkwebview (^3.15.0)

### APIs & Networking
- **HTTP Client**: http (^1.6.0)
- **Environment Variables**: flutter_dotenv (^6.0.0)
- **UUID Generation**: uuid (^4.5.2)

### Development Tools
- **Linting**: flutter_lints (^5.0.0)
- **Launcher Icons**: flutter_launcher_icons (^0.14.4)

---

## 🏗️ Architecture

### Application Architecture

Tracely follows a **layered architecture** pattern:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens, Widgets, UI Components)      │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│      (Services, State Management)       │
├─────────────────────────────────────────┤
│           Data Layer                    │
│    (Models, Firestore, API Calls)       │
├─────────────────────────────────────────┤
│         External Services               │
│  (Firebase, Google Search API, WebView) │
└─────────────────────────────────────────┘
```

### Key Architectural Patterns

#### 1. **Service-Oriented Architecture**
- `FirestoreService`: Handles all database operations
- `AuthService`: Manages authentication flows
- `SearchService`: Interfaces with Google Custom Search API

#### 2. **Repository Pattern**
- Services act as repositories for data access
- Abstracts data sources from business logic
- Centralized data management

#### 3. **Widget Composition**
- Reusable components in `/widgets`
- Atomic design principles
- Single Responsibility Principle

#### 4. **Route-Based Navigation**
- Declarative routing with go_router
- Type-safe navigation
- Deep linking support

---

## 📁 Project Structure

```
tracely_clean/
├── android/                          # Android native code
│   ├── app/
│   │   └── src/main/
│   │       ├── AndroidManifest.xml   # App configuration
│   │       └── res/                  # Android resources
│   └── build.gradle.kts              # Android build config
│
├── ios/                              # iOS native code
│   ├── Runner/
│   │   ├── Info.plist                # iOS app configuration
│   │   └── Assets.xcassets/          # iOS assets
│   └── Podfile                       # iOS dependencies
│
├── lib/                              # Main application code
│   ├── app/                          # App-level configuration
│   │   ├── router.dart               # Route definitions
│   │   └── theme.dart                # App theme & colors
│   │
│   ├── data/                         # Data layer (deprecated)
│   │   └── dummy.dart                # Legacy dummy data
│   │
│   ├── features/                     # Feature modules
│   │   └── trails/
│   │       └── trail_details.dart    # Trail detail screen
│   │
│   ├── models/                       # Data models
│   │   ├── resource.dart             # Resource model
│   │   └── trail.dart                # Trail model
│   │
│   ├── screens/                      # Screen widgets
│   │   ├── auth/                     # Authentication screens
│   │   │   ├── login/
│   │   │   │   └── login.dart        # Login screen
│   │   │   └── signup/
│   │   │       └── signup.dart       # Signup screen
│   │   ├── explore/
│   │   │   └── explore_screen.dart   # Search/explore screen
│   │   ├── home/
│   │   │   └── home_screen.dart      # Home dashboard
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart # Onboarding flow
│   │   └── profile/
│   │       └── profile_screen.dart   # User profile
│   │
│   ├── services/                     # Business logic services
│   │   ├── auth_service.dart         # Authentication service
│   │   ├── firestore_service.dart    # Firestore operations
│   │   ├── search_service.dart       # Search API integration
│   │   └── trail_matcher.dart        # Trail matching logic
│   │
│   ├── widgets/                      # Reusable widgets
│   │   ├── buttons.dart              # Custom button components
│   │   ├── card.dart                 # Trail card widget
│   │   ├── resource_preview_drawer.dart  # Resource preview
│   │   ├── resource_timeline.dart    # Resource timeline
│   │   ├── screen_wrapper.dart       # Screen layout wrapper
│   │   ├── search_result.dart        # Search result model
│   │   └── search_result_card.dart   # Search result widget
│   │
│   ├── firebase_options.dart         # Firebase configuration
│   └── main.dart                     # App entry point
│
├── assets/                           # Static assets
│   ├── fonts/                        # Custom fonts
│   │   └── PlusJakartaSans-*.ttf    # Plus Jakarta Sans font
│   ├── icons/                        # SVG icons
│   │   ├── Email.svg
│   │   ├── Lock.svg
│   │   └── ...
│   └── images/                       # Images
│       ├── tracely_logo.png          # App logo
│       ├── onboarding_1.png          # Onboarding illustration 1
│       ├── onboarding_2.png          # Onboarding illustration 2
│       └── ...
│
├── .env                              # Environment variables (not in git)
├── pubspec.yaml                      # Flutter dependencies
├── analysis_options.yaml             # Linter configuration
└── README.md                         # This file
```

---

## 🚀 Installation

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.7.2 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (^3.7.2)
   - Comes bundled with Flutter

3. **Android Studio** or **Xcode** (for respective platforms)
   - Android SDK for Android development
   - Xcode for iOS development (macOS only)

4. **Git** for version control

5. **Firebase CLI** (optional, for Firebase configuration)
   ```bash
   npm install -g firebase-tools
   ```

### Step-by-Step Installation

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd tracely_clean
```

#### 2. Install Flutter Dependencies
```bash
flutter pub get
```

#### 3. Set Up Environment Variables

Create a `.env` file in the root directory:
```env
GOOGLE_SEARCH_API_KEY=your_google_search_api_key_here
GOOGLE_SEARCH_ENGINE_ID=your_search_engine_id_here
```

#### 4. Configure Firebase

See [Firebase Setup](#firebase-setup) section below for detailed instructions.

#### 5. Generate App Icons
```bash
flutter pub run flutter_launcher_icons
```

#### 6. Run the App
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device-id>
```

---

## ⚙️ Configuration

### Theme Configuration

The app uses a custom theme defined in `lib/app/theme.dart`:

**Primary Colors:**
- Primary 900: `#004D40` (Dark Teal)
- Primary 700: `#00796B`
- Primary 500: `#26A69A`
- Primary 100: `#B2DFDB` (Light Teal)

**Secondary Colors:**
- Secondary 500: `#3ECFA1` (Mint Green)

**Neutral Colors:**
- Neutral 0: `#FFFFFF` (White)
- Neutral 100: `#F5F5F5`
- Neutral 200: `#EEEEEE`

**Accent Colors:**
- Links: `#2196F3` (Blue)

### Font Configuration

**Primary Font:** Plus Jakarta Sans
- Regular, Medium, SemiBold, Bold, ExtraBold
- Italic variants included

Configuration in `pubspec.yaml`:
```yaml
fonts:
  - family: PlusJakartaSans
    fonts:
      - asset: assets/fonts/PlusJakartaSans-Regular.ttf
      - asset: assets/fonts/PlusJakartaSans-Bold.ttf
        weight: 700
      # ... other weights
```

---

## 🔥 Firebase Setup

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Tracely" (or your preferred name)
4. Enable Google Analytics (optional)
5. Create project

### 2. Add Android App

1. In Firebase Console, click "Add app" → Android
2. Register app:
   - **Package name**: `com.example.tracely_clean` (or your package)
   - **App nickname**: Tracely Android
   - Download `google-services.json`
3. Place `google-services.json` in `android/app/`

### 3. Add iOS App

1. Click "Add app" → iOS
2. Register app:
   - **Bundle ID**: `com.example.tracelyClean` (or your bundle ID)
   - **App nickname**: Tracely iOS
   - Download `GoogleService-Info.plist`
3. Place `GoogleService-Info.plist` in `ios/Runner/`

### 4. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Enable sign-in methods:
   - ✅ Email/Password
   - ✅ Google
4. For Google Sign-In:
   - Add your app's SHA-1 fingerprint (Android)
   - Configure OAuth consent screen

### 5. Create Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose a location (e.g., us-central1)

### 6. Configure Security Rules

Set up Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User must be authenticated
    match /trails/{trailId} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
    
    match /resources/{resourceId} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
  }
}
```

### 7. Generate Firebase Configuration

Run FlutterFire CLI:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This generates `lib/firebase_options.dart` with your Firebase configuration.

---

## 🔍 API Integration

### Google Custom Search API

Tracely uses Google Custom Search JSON API for web search functionality.

#### Setup Steps:

1. **Get API Key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create/select a project
   - Enable "Custom Search API"
   - Create credentials → API Key
   - Copy the API key

2. **Create Custom Search Engine:**
   - Go to [Programmable Search Engine](https://programmable-search.google.com/)
   - Click "Add"
   - Configure:
     - **Sites to search**: Select "Search the entire web"
     - **Name**: Tracely Search
   - Create and get the Search Engine ID

3. **Add to Environment Variables:**
   ```env
   GOOGLE_SEARCH_API_KEY=AIzaSy...your_key
   GOOGLE_SEARCH_ENGINE_ID=your_search_engine_id
   ```

#### API Implementation

Located in `lib/services/search_service.dart`:

```dart
class SearchService {
  Future<List<SearchResult>> search(String query) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/customsearch/v1'
        '?key=$apiKey'
        '&cx=$searchEngineId'
        '&q=$query'
      )
    );
    // Parse and return results
  }
}
```

#### API Quotas:
- **Free Tier**: 100 queries per day
- **Paid**: Up to 10,000 queries per day

---

## 🎨 UI/UX Design

### Design Principles

1. **Minimalist Interface**: Clean, uncluttered design
2. **Intuitive Navigation**: Tab-based navigation with clear icons
3. **Visual Hierarchy**: Important actions are prominent
4. **Consistent Spacing**: 4px grid system
5. **Smooth Animations**: Delightful micro-interactions

### Color Psychology

- **Teal/Green**: Growth, learning, and progress
- **White/Light Gray**: Clean, professional
- **Mint Green**: Success states, completed actions

### Typography Scale

```
Hero Text:     28px (Bold)
Title:         24px (Bold)
Heading:       20px (SemiBold)
Body:          16px (Regular)
Caption:       14px (Regular)
Small:         12px (Regular)
```

### Component Library

#### Buttons
- **Primary Button**: Solid background, used for main actions
- **Secondary Button**: Outlined, used for alternative actions
- **Icon Button**: Circular, used for compact actions

#### Cards
- **Trail Card**: Displays trail information with stats
- **Resource Card**: Shows individual resources in timeline
- **Search Result Card**: Displays search results with preview

#### Input Fields
- **Text Field**: Email, password, search inputs
- **Search Bar**: Dedicated search component with icon

---

## 🔄 State Management

### Approach: StatefulWidget + Services

Tracely uses a **service-oriented** approach with StatefulWidget for local state:

```dart
// Screen holds local UI state
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Service instances
  final _firestoreService = FirestoreService();
  
  // Local state
  List<Trail> _trails = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadTrails(); // Fetch data on init
  }
  
  Future<void> _loadTrails() async {
    final trails = await _firestoreService.getTrailsForUser(userId);
    setState(() {
      _trails = trails;
      _isLoading = false;
    });
  }
}
```

### Why This Approach?

✅ **Simplicity**: Easy to understand and maintain
✅ **Suitable for app size**: Perfect for small-to-medium apps
✅ **Less boilerplate**: No need for complex state management
✅ **Direct**: Services provide data directly to widgets

### Future Considerations

For scaling, consider:
- **Provider** for app-wide state
- **Riverpod** for more complex state dependencies
- **BLoC** for enterprise-level state management

---

## 📊 Data Models

### Trail Model

```dart
class Trail {
  String id;
  String userId;
  String title;
  String subtitle;
  DateTime createdAt;
  DateTime lastAccessed;
  
  // Computed from resources
  int resourceCount;
  int totalTimeSpentSeconds;
}
```

**Firestore Collection:** `trails`

### Resource Model

```dart
class Resource {
  String id;
  String userId;
  String trailId;          // Links to Trail
  ResourceType type;       // link, document, youtube
  
  String title;
  String source;           // URL
  String domain;
  
  Map<String, dynamic> metadata;
  
  int visitCount;
  Duration timeSpent;
  DateTime createdAt;
  DateTime lastVisited;
}
```

**Firestore Collection:** `resources`

### Resource Types

```dart
enum ResourceType {
  link,      // Web pages
  document,  // PDFs
  youtube    // YouTube videos
}
```

---

## 🔒 Security

### Authentication Security

✅ **Secure Password Storage**: Handled by Firebase Auth
✅ **Email Verification**: Optional verification flow
✅ **Session Management**: Automatic token refresh
✅ **Sign Out**: Proper cleanup on logout

### Data Security

✅ **Firestore Security Rules**: User can only access their own data
✅ **API Key Protection**: Keys stored in `.env` (not in version control)
✅ **HTTPS Only**: All network requests use HTTPS

### Best Practices Implemented

1. **No Hardcoded Credentials**: All sensitive data in `.env`
2. **User-Scoped Data**: Each user sees only their data
3. **Input Validation**: Forms validate before submission
4. **Error Handling**: Graceful error messages, no sensitive info leaked

### Security Checklist

- [x] Firebase Security Rules configured
- [x] API keys in environment variables
- [x] `.env` in `.gitignore`
- [x] User authentication required for all data operations
- [x] HTTPS for all external requests
- [x] No sensitive data in logs

---

## 🧪 Testing

### Manual Testing

The app has been manually tested on:
- ✅ Android devices (various screen sizes)
- ✅ Android emulators
- ✅ iOS simulators (if applicable)

### Test Coverage

**Authentication:**
- [x] Sign up with email/password
- [x] Sign in with email/password
- [x] Sign in with Google
- [x] Sign out
- [x] Password reset

**Core Features:**
- [x] Create trail
- [x] Search web resources
- [x] Preview resources (web, YouTube, PDF)
- [x] Save resources to trails
- [x] View trail details
- [x] View resource timeline

**Edge Cases:**
- [x] No internet connection
- [x] Empty states (no trails, no resources)
- [x] Loading states
- [x] Error handling

### Future Testing

To implement:
- Unit tests for services
- Widget tests for UI components
- Integration tests for user flows
- Performance testing

---

## 🚀 Future Enhancements

### Planned Features

#### Phase 1: Core Improvements
- [ ] **Offline Mode**: Cache trails and resources for offline access
- [ ] **Search Filters**: Filter by date, type, domain
- [ ] **Sort Options**: Sort trails and resources by various criteria
- [ ] **Edit Trails**: Update trail title and subtitle
- [ ] **Delete Resources**: Remove resources from trails
- [ ] **Resource Notes**: Add personal notes to resources

#### Phase 2: Collaboration
- [ ] **Share Trails**: Share trails with other users
- [ ] **Public Trails**: Make trails discoverable by others
- [ ] **Follow Users**: Follow other learners
- [ ] **Trail Templates**: Pre-made trail templates for popular topics

#### Phase 3: Analytics
- [ ] **Learning Analytics**: Visualize learning patterns
- [ ] **Time Tracking Dashboard**: See time spent per trail/topic
- [ ] **Progress Indicators**: Track completion of learning goals
- [ ] **Statistics**: Total resources, trails, time spent

#### Phase 4: AI Integration
- [ ] **Smart Recommendations**: AI-suggested resources based on trail
- [ ] **Auto-Categorization**: Automatically categorize resources
- [ ] **Summary Generation**: AI-generated summaries of resources
- [ ] **Quiz Generation**: Auto-generate quizzes from resources

#### Phase 5: Platform Expansion
- [ ] **Web Version**: Progressive Web App
- [ ] **Desktop Apps**: Windows, macOS, Linux
- [ ] **Browser Extension**: Save resources from any browser
- [ ] **API**: Public API for third-party integrations

---

## 🤝 Contributing

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Commit with clear messages**
   ```bash
   git commit -m "Add: Amazing feature description"
   ```
5. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style
- Write clear commit messages
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation if needed

### Code Style

- Use **2 spaces** for indentation
- Follow Dart [style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Keep functions small and focused

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2026 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📞 Contact & Support

**Developer:** _[Your Name]_

**Email:** _[Your Email]_

**GitHub:** _[Your GitHub Profile]_

**Project Repository:** _[Repository URL]_

---

## 🙏 Acknowledgments

### Technologies & Services
- **Flutter Team** for the amazing framework
- **Firebase** for backend infrastructure
- **Google** for Custom Search API
- **Material Design** for design guidelines

### Assets & Resources
- **Plus Jakarta Sans** font by Tokotype
- **Iconsax** icon library
- Custom illustrations created for this project

### Inspiration
This project was inspired by the need for better learning resource organization and the desire to help students track their learning journey effectively.

---

## 📸 Screenshots

_[Add your app screenshots here]_

### Onboarding
![Onboarding Screen 1](screenshots/onboarding_1.png)
![Onboarding Screen 2](screenshots/onboarding_2.png)

### Authentication
![Login Screen](screenshots/login.png)
![Signup Screen](screenshots/signup.png)

### Main Features
![Home Screen](screenshots/home.png)
![Explore Screen](screenshots/explore.png)
![Trail Details](screenshots/trail_details.png)
![Profile Screen](screenshots/profile.png)

---

## 📈 Project Statistics

**Total Lines of Code:** ~15,000+ lines
**Number of Screens:** 7 main screens
**Number of Widgets:** 15+ custom widgets
**Number of Services:** 4 core services
**Number of Models:** 2 main models

**Development Time:** _[Your timeframe]_

**Version:** 1.0.0

---

## 🎓 Learning Outcomes

This project demonstrates proficiency in:

### Technical Skills
- ✅ Flutter & Dart development
- ✅ Firebase integration (Auth, Firestore, Messaging)
- ✅ RESTful API integration
- ✅ State management
- ✅ Responsive UI design
- ✅ Navigation & routing
- ✅ Asynchronous programming
- ✅ Error handling
- ✅ Version control (Git)

### Software Engineering Practices
- ✅ Clean code architecture
- ✅ Separation of concerns
- ✅ Reusable components
- ✅ Documentation
- ✅ Version control
- ✅ Security best practices

### Problem-Solving
- ✅ Identifying real-world problems
- ✅ Designing user-centric solutions
- ✅ Implementing complex features
- ✅ Debugging and optimization

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 1. Build Errors

**Issue:** Gradle build fails
```bash
Error: Could not resolve all dependencies
```

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### 2. Firebase Not Connecting

**Issue:** Firebase services not working

**Solution:**
- Check `google-services.json` is in `android/app/`
- Check `GoogleService-Info.plist` is in `ios/Runner/`
- Verify package name matches Firebase console
- Run `flutterfire configure` again

#### 3. API Key Issues

**Issue:** Search not working

**Solution:**
- Check `.env` file exists and has correct keys
- Verify API key is enabled in Google Cloud Console
- Check API quotas haven't been exceeded

#### 4. WebView Not Loading

**Issue:** Resources not displaying in preview

**Solution:**
- Enable internet permissions in AndroidManifest.xml
- Add App Transport Security settings for iOS
- Check URL is valid HTTPS

---

## 📚 Additional Resources

### Flutter Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### Firebase Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

### API Resources
- [Google Custom Search API](https://developers.google.com/custom-search)
- [YouTube API](https://developers.google.com/youtube/v3)

---

## 🎯 Conclusion

Tracely represents a comprehensive solution to the problem of scattered learning resources. By providing an intuitive interface to search, organize, and track learning materials, it empowers users to take control of their educational journey.

The application successfully demonstrates modern mobile app development practices, including:
- Clean architecture
- Cloud integration
- RESTful API consumption
- Beautiful, responsive UI
- Secure authentication
- Real-time data synchronization

This project serves as a solid foundation for a production-ready learning management application and showcases the power of Flutter for cross-platform mobile development.

---

**Built with ❤️ using Flutter**

**© 2026 Tracely - All Rights Reserved**

