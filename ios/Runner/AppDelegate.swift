import Flutter
import UIKit
import GoogleMaps


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //GET OUR OWN MAPS ID
    GMSServices.provideAPIKey("AIzaSyAIO-3vFI_0dmGTdOv9oojSnbXNysdXxmQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
