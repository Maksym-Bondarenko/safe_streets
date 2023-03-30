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

    GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey:"googleMapsApiKey") as? String ?? "");

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
