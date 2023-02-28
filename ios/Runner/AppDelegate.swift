import UIKit
import Flutter
import GoogleMaps  // for google-maps api

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyBOUh5JXj3j97dKR55KnpSmp9xPX0AzoVk")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
