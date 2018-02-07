//
//  MasterConvenience.swift
//  On The Map
//
//  Created by Yash Rao on 1/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


struct ErrorMessages {
    let DataError = "Error with Data"
    let MapError = "Error with UIMapKit"
    let LoginCredentialsError = "Invalid credentials"
    let CallDataError = "No data returned, Check your network connection"
    let ParseError = "The key you are searching for does not exist"
    let LoginSelfError = "Cannot retrieve User Information"
    let GETError = "GET request for student location data was unsuccessful"
    let webError = "Invalid website request"
    let emptyURL = "Please provide a URL"
    let httpURL = "Please ensure that the URL begins with http:// or https://"
    let locationError = "Geocode Error, Please try again"
    let postError = "Unable to post a pin for new/existing user!"
    let connectionError = "Please check your network connection!"
    
}

extension MasterNetwork {
    
    func alertError(_ controller: UIViewController, error: String) {
        let alertView = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alertView, animated: true, completion: nil)
    }
    
    //Check internet connection code - Thanks to StackOverflow! (https://stackoverflow.com/questions/39558868/check-internet-connection-ios-10)
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

}




