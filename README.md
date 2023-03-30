# 🗺️ safe_streets

Safe Streets assists girls, children, seniors, and other groups that don’t feel safe while getting around the city on their own.

«From Safe Streets to safe cities, countries and the world!»

[![Flutter Version](https://img.shields.io/badge/flutter-2.5-blue)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/dart-2.14.4-blue)](https://dart.dev/)
[![Google Maps API](https://img.shields.io/badge/google%20maps-API-red)](https://cloud.google.com/maps-platform/)
[![Firebase](https://img.shields.io/badge/firebase-8.6.0-orange)](https://firebase.google.com/)
[![Google Cloud Platform](https://img.shields.io/badge/google%20cloud-platform-blue)](https://cloud.google.com/)

## 📝 Description

TODO

## 💻 Technologies used

For the proof of concept, we built a 3-tier application on the Google cloud platform. The presentation layer was built on Flutter. For the business logic tier, we launched a docker container on a VM instance using Flask Python. Finally, the database is a PostgreSQL server, which is stored in Cloud SQL. The connection between the frontend and the backend was implemented using the REST API.
Before deploying an application to production, we are going to transfer the backend server to Google Kubernetes Engine. Since users will update danger points frequently, we will deploy an in-memory database for the points.

* [Flutter](https://flutter.dev/) - The framework used
* [Dart](https://dart.dev/) - The language used
* [Google Maps API](https://cloud.google.com/maps-platform/) - Used for maps and location services
* [Firebase](https://firebase.google.com/) - Used for authentication
* [Google Cloud Platform](https://cloud.google.com/) - Used for cloud services

## 👥 Authors
* [Maksym Bondarenko](https://github.com/Maksym-Bondarenko)
* [Chernov Andrey](https://github.com/ChernovAndrey)
* [Ekaterina Erofeeva](https://github.com/ekaterina-erofeeva)
* [Kira Dianova](https://github.com/keira-d)

## 🚀 Getting Started

To get started with this project, you'll need to have Flutter installed on your local machine. You can follow the installation instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).

### 🦾 Prerequisites

You'll also need to have the following software installed:

- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) (with Flutter and Dart plugins) for development
- A Google Cloud Platform account with the Maps API and Firebase services enabled

### 🦿 Installation

1. Clone this repository to your local machine using `git clone https://github.com/Maksym-Bondarenko/safe_streets.git`.
2. Run `flutter pub get` to install the required dependencies.
3. Create a new project in the Firebase console and add the required services (e.g., Authentication, Firestore, etc.).
4. Configure the Maps API keys in the Google Cloud Platform console and add them to the `AndroidManifest.xml` and `AppDelegate.swift` files.
5. Run the app using `flutter run`.

You should now be able to run the app on your emulator or physical device.

### ⚙ Configuration

Before running the app, you'll need to add your Firebase configuration file to the project. You can follow the [Firebase documentation](https://firebase.google.com/docs/flutter/setup#add-config-file) for instructions on how to do this.

You'll also need to configure the Maps API keys in the `AndroidManifest.xml` and `AppDelegate.swift` files. You can follow the [Google Cloud Platform documentation](https://developers.google.com/maps/gmp-get-started/api-key) for instructions on how to do this.

### 🚫 Limitations:

* Currently following pages are placeholders with dummy data and with no functionality: 'dds_map.dart', 'edit_user_details_page.dart', 'forum_page.dart', 'settings_page.dart' and 'faq_page.dart'
* As Data Driven Styling (DDS) by Google Maps for Flutter Applications is currently under development, we could not implement it into our maps
* Also, currently we faced problems with fetching data from the backend (markers of custom user points: DangerPoints and RecommendationPoints) on Android. On iOS it works on other hand. It should be a problem on Google-side ([Google Issue Tracker](https://issuetracker.google.com/issues/228091313?pli=1) and [GitHub Issue](https://github.com/flutter/flutter/issues/109115)), so we are waiting for the fix to implement it in our app.

### 🔮 Future Work:

* Updating the current placeholders for the settings-page, change-user-details-page, and forum-page to provide a better user experience and more functionality.
* On the settings-page, add options for changing user preferences such as language, time zone, and notification settings.
* Implement voting for points (dangerPoint, recommendationPoint and safePoint) and logic for their auto-deletion
* Add overall information for regions from DDS, containing report details, such as: last criminal rate, amount of thefts; touristic advices for countries
* On the change-user-details-page, allow users to update their profile information such as name, email address, and profile picture.
* On the forum-page, add features such as upvoting and downvoting posts, write own posts, and sorting posts by popularity, date, or relevance.
* Improve the user interface and design of all three pages to make them more visually appealing and easier to navigate.
* Provide clustering of map-markers by zoom-out
* Add unit and integration tests for these pages to ensure that they are functioning correctly and to prevent any regressions in functionality.
* Consider adding support for additional languages to make the website accessible to a wider audience.

### 🧪 Tested on:

The application was tested on mobile devices with Android and iOS:
* Android 13 (Xiaomi 11T)
* iOS 16.2 (iPhone 12)

### 🔧 Were used following dependencies and their versions:

cupertino_icons: ^1.0.2
firebase_core: ^2.7.0
firebase_auth: ^4.2.9
flutterfire_ui: ^0.4.3+20
google_sign_in: ^5.4.4
google_maps_flutter: ^2.2.3
google_maps_flutter_web: ^0.4.0+5
http: ^0.13.5
json_serializable: ^6.6.1
json_annotation: ^4.8.0
flutter_native_splash: ^2.2.19
flutter_polyline_points: ^1.0.0
geocoding: ^2.1.0
firebase_messaging: ^14.2.6
permission_handler: ^10.2.0
intro_slider: ^3.0.9
dio: ^5.0.1
connectivity_plus: ^3.0.3
location: ^4.4.0
provider: ^6.0.5
fluster: ^1.2.0
fluttertoast: ^8.2.1
cached_network_image: ^3.2.3
flutter_js: ^0.6.0
geolocator: ^9.0.2
custom_info_window: ^1.0.1
grpc: ^3.1.0
flutter_speed_dial: ^6.2.0
google_maps_cluster_manager: ^3.0.0+1
flutter_launcher_icons: ^0.12.0
url_launcher: ^6.1.10
flutter_email_sender: ^5.2.0
image_picker: ^0.8.7
shared_preferences: ^2.0.20