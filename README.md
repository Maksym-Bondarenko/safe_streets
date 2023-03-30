# 🗺️ safe_streets

Safe Streets assists women, children, seniors, and other groups that don’t feel safe while getting
around the city on their own.

«From Safe Streets to safe cities, countries and the world!»

[![Flutter Version](https://img.shields.io/badge/flutter-3.7.7da-blue)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/dart-2.19.4-blue)](https://dart.dev/)
[![Flask Version](https://img.shields.io/badge/Flask-v2.1.1-red)](https://flask.palletsprojects.com/en/2.1.x/)
[![PostgreSQL Version](https://img.shields.io/badge/PostgreSQL-v14.1-blue)](https://www.postgresql.org/)
[![Docker Version](https://img.shields.io/badge/Docker-v20.10.23-blue)](https://www.docker.com/)
[![Firebase](https://img.shields.io/badge/firebase-11.23.1-orange)](https://firebase.google.com/)
[![Google Maps API](https://img.shields.io/badge/google%20maps-API-red)](https://cloud.google.com/maps-platform/)
[![Google Cloud Platform](https://img.shields.io/badge/google%20cloud-platform-blue)](https://cloud.google.com/)

## 📝 Description

TODO

Watch our [You-Tube video](https://youtu.be/pJbVnoq-iaQ) to get the overview of our app!

## 💻 Technologies used

For the proof of concept, we built a 3-tier application on the Google cloud platform. The
presentation layer was built on Flutter. For the business logic tier, we launched a docker container
on a VM instance using Flask Python. Finally, the database is a PostgreSQL server, which is stored
in Cloud SQL. The connection between the frontend and the backend was implemented using the REST
API.
Before deploying an application to production, we are going to transfer the backend server to Google
Kubernetes Engine. Since users will update danger points frequently, we will deploy an in-memory
database for the points.

* [Flutter](https://flutter.dev/) - The framework used
* [Dart](https://dart.dev/) - The language used
* [Flask Python](https://flask.palletsprojects.com) - For backend
* [PostgreSQL](https://www.postgresql.org/) - for Database
* [Docker](https://www.docker.com/) - for running Server in container
* [Google Maps API](https://cloud.google.com/maps-platform/) - Used for maps and location services
* [Firebase](https://firebase.google.com/) - Used for authentication
* [Google Cloud Platform](https://cloud.google.com/) - Used for cloud services

## 🚀 Getting Started

To get started with this project, you'll need to have Flutter installed on your local machine. You
can follow the installation instructions on
the [Flutter website](https://flutter.dev/docs/get-started/install).

### 🦾 Prerequisites

You'll also need to have the following software installed:

- [Android Studio](https://developer.android.com/studio)
  or [Visual Studio Code](https://code.visualstudio.com/) (with Flutter and Dart plugins) for
  development
- A Google Cloud Platform account with the Maps API and Firebase services enabled

### 🦿 Installation

1. Clone this repository to your local machine
   using `git clone https://github.com/Maksym-Bondarenko/safe_streets.git`.
2. Run `flutter pub get` to install the required dependencies.
3. Create a new project in the Firebase console and add the required services (e.g., Authentication,
   Firestore, etc.).
4. Configure the Maps API keys in the Google Cloud Platform console and add them to
   the `AndroidManifest.xml` and `AppDelegate.swift` files.
5. Run the app using `flutter run`.

You should now be able to run the app on your emulator or physical device.

### ⚙ Configuration

Before running the app, you'll need to add your Firebase configuration file to the project. You can
follow the [Firebase documentation](https://firebase.google.com/docs/flutter/setup#add-config-file)
for instructions on how to do this.

You'll also need to configure the Maps API keys in the `AndroidManifest.xml`, `AppDelegate.swift`
, `index.html` files and in all places where it is used for http-calls. You can follow
the [Google Cloud Platform documentation](https://developers.google.com/maps/gmp-get-started/api-key)
for instructions on how to do this.

If you want to start a local server, start Docker, go to the `backend` folder, open console and type
following commands:
`docker build .`
`docker tag <id_of_built_image> run_db`
`docker run -p 8080:8080 run_db`
Those commands will start the server locally on your machine via docker.
To be able fetch and save the points, you have to change in code `host` variable from its value to `"localhost"` (you need to
uncomment some lines of code in `start_page.dart` and `dialog_window.dart`, that are mentioned in
comments).
You can try (e.g. via Postman) run a get-request: `http://127.0.0.1:8080/get/all_places` and see all already created points.

### 🚫 Limitations:

* Currently following pages are placeholders with dummy data and with no
  functionality: `dds_map.dart`, `edit_user_details_page.dart`, `forum_page.dart`
  , `settings_page.dart` and `faq_page.dart`
* As Data Driven Styling (DDS) by Google Maps for Flutter Applications is currently under
  development, we could not implement it into our maps
* Also, currently we faced problems with fetching data from the backend (markers of custom user
  points: DangerPoints and RecommendationPoints) on Android. On iOS it works on other hand. It
  should be a problem on
  Google-side ([Google Issue Tracker](https://issuetracker.google.com/issues/228091313?pli=1)
  and [GitHub Issue](https://github.com/flutter/flutter/issues/109115)), so we are waiting for the
  fix to implement it in our app.

### 🔮 Future Work:

* Updating the current placeholders for the settings-page, change-user-details-page, and forum-page
  to provide a better user experience and more functionality.
* On the settings-page, add options for changing user preferences such as language, time zone, and
  notification settings.
* Implement voting for points (dangerPoint, recommendationPoint and safePoint) and logic for their
  auto-deletion
* Add overall information for regions from DDS, containing report details, such as: last criminal
  rate, amount of thefts; touristic advices for countries
* On the change-user-details-page, allow users to update their profile information such as name,
  email address, and profile picture.
* On the forum-page, add features such as upvoting and downvoting posts, write own posts, and
  sorting posts by popularity, date, or relevance.
* Improve the user interface and design of all three pages to make them more visually appealing and
  easier to navigate.
* Provide clustering of map-markers by zoom-out
* Add unit and integration tests for these pages to ensure that they are functioning correctly and
  to prevent any regressions in functionality.
* Consider adding support for additional languages to make the website accessible to a wider
  audience.

## 👥 Authors

* [Maksym Bondarenko](https://github.com/Maksym-Bondarenko)
* [Chernov Andrey](https://github.com/ChernovAndrey)
* [Ekaterina Erofeeva](https://github.com/ekaterina-erofeeva)
* [Kira Dianova](https://github.com/keira-d)

### 📷 App-Screenshots

There are some of screenshots of SafeStreets-App:

![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot1_intro-slider.jpg "Intro-slider")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot2_main-screen.jpg "Main screen")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot3_dds-map.jpg "DDS map")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot4_user-profile.jpg "User profile")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot5_user-profile.jpg "User profile")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot6_filter-map.jpg "Filter map")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot7_safe-point.jpg "Safe point")
![Screenshot of SafeStreets](/lib/assets/screenshots/screenshot8_point-creation.jpg "point creation")

### 🧪 Tested on:

The application was tested on mobile devices with Android and iOS:

* Android 13 (Xiaomi 11T)
* iOS 16.2 (iPhone 12)
