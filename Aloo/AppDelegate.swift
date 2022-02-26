//
//  AppDelegate.swift
//  Aloo
//
//  Created by macbook on 9/22/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        L102Localizer.DoTheMagic()
        GMSServices.provideAPIKey("AIzaSyAJDF5zpu0jWLw1Soy6rdyqQTkODU2ax1s")
        GMSPlacesClient.provideAPIKey("AIzaSyAJDF5zpu0jWLw1Soy6rdyqQTkODU2ax1s")
        FirebaseApp.configure()
        registerForPushNotifications()
        application.registerForRemoteNotifications()
        if UserDefaults.standard.string(forKey: "AppLang") == nil{
            UserDefaults.standard.setValue("en", forKey: "AppLang")
        }
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}



extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func registerForPushNotifications() {
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            //  Errors Here 
        }
        
    }
    
    /// this method called once ... when the user reinstall the app
    /// new registration token will created to send it to server
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // send fcmtoken to server
        if let fcmToken = fcmToken{
            print("FCMToken :: \(fcmToken)")
            
//            ProfileApiControllers.firebaseToken(token: fcmToken) { status, message in
//                if !status{
//                    if let window = self.window{
//                        DispatchQueue.main.async {
//                            GeneralActions.shard.showAlert(viewController: window.rootViewController!, title: "Error", message: message)
//                        }
//                    }
//                }
//            }
        }
    }
    
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
}

