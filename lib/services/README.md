# Services

This folder contains service files responsible for communicating with the backend and other services, providing internal functionality for the application.

## Structure

The structure of the 'services' folder is as follows:

services/
├── base_service.dart
├── firebase_options.dart
├── manual_points_service.dart
├── notifications_service.dart
├── path_service.dart
├── safe_points_service.dart
└── README.md

## Usage

To use the services in your application:

1. Import the desired service file into your Dart file:

```dart
import 'package:your_app/services/base_service.dart';
import 'package:your_app/services/manual_points_service.dart';
import 'package:your_app/services/safe_points_service.dart';
```

2. Instantiate the required service class:

```dart
var baseService = BaseService();
var manualPointsService = ManualPointsService();
var safePointsService = SafePointsService();
```

For detailed usage instructions, refer to the individual service files.
