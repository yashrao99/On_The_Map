//
//  AppDelegate.swift
//  On The Map
//
//  Created by Yash Rao on 1/21/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    
    //POST Udacity API call variables
    var userID: String? = nil
    var sessionID: String? = nil
    
    //GET User data Udacity API call variables
    var firstName: String = ""
    var lastName: String = ""
    var objectID: String = ""
    var uniqueKey: String = ""
    var mapString: String = ""
    var mediauRL: String = ""
    var latitude: Double = 0.00
    var longitude: Double = 0.00
        
    let errorMessages = ErrorMessages()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}




