//
//  UsersData.swift
//  On The Map
//
//  Created by Yash Rao on 1/31/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct UsersData {
    
    //Information to extract for GET call
    var firstName:String
    var lastName: String
    let mediaURL:String
    var objectID: String
    var uniqueKey: String
    let lat: Double
    let long: Double
    
    //This dictionary will store all the user information, need one for EACH user
    init?(dictionary: [String:Any]) {
        let firstName = dictionary["firstName"] as? String ?? ""
        let lastName = dictionary["lastName"] as? String ?? ""
        let mediaURL = dictionary["mediaURL"] as? String ?? ""
        let objectID = dictionary["objectId"] as? String ?? ""
        let uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        let lat = dictionary["latitude"] as? Double ?? 0.00
        let long = dictionary["longitude"] as? Double ?? 0.00
        
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.lat = lat
        self.long = long
    }
    //Take the array of dictionaries from the GET call and sort them into an array of dictionaries defined by the struct for each user
    static func CompileUsersData(_ results:[[String:Any]]) -> [UsersData] {
        
        var usersList = [UsersData]()
        
        for result in results {
            if let testData = UsersData(dictionary: result) {
                usersList.append(testData)
            }
        }
        return usersList
    }
    
    static var dataArray: [UsersData] = []
}
