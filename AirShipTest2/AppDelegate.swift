//
//  AppDelegate.swift
//  AirShipTest2
//
//  Created by Lewis W. Johnson on 6/5/15.
//  Copyright (c) 2015 hamiltoholt.com. All rights reserved.
//

import UIKit
import AirshipKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var uaShared:UAirship?
    var uapush:UAPush?
    var config:UAConfig?
    var channel:String?
    



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
   
        // Display a UIAlertView warning developers that push notifications do not work in the simulator
        //  remove this in your app.
        failIfSimulator()
        
        // Set log level for debugging config loading (optional)
        // It will be set to the value in the loaded config upon takeOff
        UAirship.setLogLevel(UALogLevel.Trace)
        
        // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
        // or set runtime properties here.
        config = UAConfig.defaultConfig()
        
        // You can then programmatically override the plist values:
        // config.developmentAppKey = "YourKey";
        // etc.
        config!.automaticSetupEnabled = false;
        config!.detectProvisioningMode = true;
        
        // Call takeOff (which creates the UAirship singleton)
        UAirship.takeOff(config)
        
        // Print out the application configuration for debugging (optional)
        println("Config: \(config!.description)");
        
        //Get the shared instance of UA Singleton
        uaShared = UAirship.shared() // returns nil until we are authenticated
        
        //Returns the `UAPush` instance. Used for configuring and managing push notifications.
        uapush = UAirship.push()
    
        // Set the icon badge to zero on startup (optional)
        
        uapush?.resetBadge() // wrapped so wont blow when null
        
        channel? = uapush!.channelID //get a handle on channel it supercedes token
        
        // Set the notification types required for the app (optional). This value defaults
        // to badge, alert and sound, so it's only necessary to set it if you want
        // to add or remove types.
        uapush?.userNotificationTypes = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
        
        
        uapush?.userPushNotificationsEnabled = true //dont delay asking user about push notification as they suggest. Our users are employees
        
        
        
        
        return true
    }
    
    func failIfSimulator(){
        if (UIDevice.currentDevice().model.rangeOfString("Simulator") != nil){
            let alert = UIAlertView()
            alert.title     = "Notice"
            alert.message   = "You will not be able to receive push notifications in the simulator."
            alert.addButtonWithTitle("OK")
            
            // Let the UI finish launching first so it doesn't complain about the lack of a root view controller
            // Delay execution of the block for 1/2 second.
            
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue())
                {
                    alert.show()
            }
        }
    }
    
    // since we set config!.automaticSetupEnabled = false, we have to implement these ourself, that's what we want for now anyway
    // we also notify their push object
    // converted
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
       
        println("Application registered for remote notifications with device token: \(deviceToken)");
        uapush?.appRegisteredForRemoteNotificationsWithDeviceToken(deviceToken)
        
    }
    // converted
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        println("Application did register with user notification types: \(notificationSettings)");
        uapush?.appRegisteredUserNotificationSettings()
        
    }
    // converted
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        println("Failed to register for remote notifications: \(error)")
    }

    // converted
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        println("Application received remote notification: \(userInfo)")
        uapush?.appReceivedRemoteNotification(userInfo, applicationState: application.applicationState)
    }
    // converted
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        println("Application received remote notification: \(userInfo)")
        uapush?.appReceivedRemoteNotification(userInfo, applicationState: application.applicationState, fetchCompletionHandler: completionHandler)
    }
    // converted
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void)
    {
        println("Received remote notification button interaction: identifier: \(userInfo,identifier)")
        uapush?.appReceivedActionWithIdentifier(identifier, notification: userInfo, applicationState: application.applicationState, completionHandler: completionHandler)
    }
    

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        uapush?.resetBadge()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

