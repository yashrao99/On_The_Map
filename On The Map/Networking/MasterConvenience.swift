//
//  MasterConvenience.swift
//  On The Map
//
//  Created by Yash Rao on 1/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit



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
    let locationError = "Pleae enter a valid location"
    let postError = "Unable to post a pin for new/existing user!"
    
}

extension MasterNetwork {
    
    func alertError(_ controller: UIViewController, error: String) {
        let alertView = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alertView, animated: true, completion: nil)
    }
    
    
    func segueToSearchVC(_ controller: UIViewController) {
        let searchLocationVC = controller.storyboard?.instantiateViewController(withIdentifier: "searchLocationVC")
        controller.present(searchLocationVC!, animated: true, completion: nil)
    }
    
    func segueToTabVC(_ controller: UIViewController) {
        let tabBarVC = controller.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
        controller.present(tabBarVC!, animated: true, completion: nil)
    }
    
    func segueToLoginVC(_ controller: UIViewController) {
        let loginVC = controller.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        controller.present(loginVC!, animated: true, completion: nil)
    }
}

