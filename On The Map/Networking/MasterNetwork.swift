//
//  MasterNetwork.swift
//  On The Map
//
//  Created by Yash Rao on 1/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MasterNetwork: NSObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init() {
        super.init()
    }
    
    func loginToUdacity(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            
            func handleError( error: String, errorString: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, errorString, NSError(domain: "loginToUdacity", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                handleError(error: "There is an error with your request, \(error)", errorString: self.appDelegate.errorMessages.DataError)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handleError(error: "Your request returned a status code other than 2xx", errorString: self.appDelegate.errorMessages.LoginCredentialsError)
                return
            }
            guard let data = data else {
                handleError(error: "No data was returned!", errorString: self.appDelegate.errorMessages.CallDataError)
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
            } catch {
                print("Could not parse data as JSON: \(newData)")
                return
            }
            
            
            guard let account = parsedResult["account"] as? [String:Any] else {
                handleError(error: "Cannot find key 'account' in parsedResult", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
            
            guard let session = parsedResult["session"] as? [String:Any] else {
                handleError(error: "Cannot find key 'session' in parsedResult", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
            
            guard let userID = account["key"] as? String else {
                handleError(error: "Cannot find key 'Key' in account", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
            
            
            guard let sessionID = session["id"] as? String else {
                handleError(error: "Cannot find key 'id' in session", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
        
            self.appDelegate.userID = userID
            self.appDelegate.sessionID = sessionID
            self.appDelegate.uniqueKey = userID
            print(userID)
            
            completionHandlerForAuth(true, nil, nil)
        }
        task.resume()
    }
    
    func getUserData(userID: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            
            func handleError( error: String, errorString: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                handleError(error: "Error with request made", errorString: self.appDelegate.errorMessages.DataError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handleError(error: "Your request returned a status code other than 2xx", errorString: self.appDelegate.errorMessages.LoginCredentialsError)
                return
            }
            guard let data = data else {
                handleError(error: "No data was returned!", errorString: self.appDelegate.errorMessages.CallDataError)
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
            } catch {
                print("Could not parse data as JSON: \(newData)")
                return
            }
            
            guard let userDictionary = parsedResult["user"] as? [String: AnyObject] else {
                handleError(error: "Cannot find key 'user' in parsedResult", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
                        
            guard let firstName = userDictionary["first_name"] as? String else {
                handleError(error: "Cannot find key 'first_name' in userDictionary", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }
            
            guard let lastName = userDictionary["last_name"] as? String else {
                handleError(error: "Cannot find key 'last_name' in userDictionary", errorString: self.appDelegate.errorMessages.ParseError)
                return
            }

            self.appDelegate.firstName = firstName
            self.appDelegate.lastName = lastName
            print(firstName)
            print(lastName)

            
            completionHandlerForAuth(true, nil)
        }
        task.resume()
    }
    
    func getRequestStudentLocationTest(completionHandlerForUserData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = [Constants.ParseOptionalParameters.Limit: 100 as AnyObject, Constants.ParseOptionalParameters.Order:"-updatedAt" as AnyObject]
        let url = buildParseURL(parameters, withPathExtension: Constants.ParseURLKeys.StudentLocation)
        
        let request = NSMutableURLRequest(url: url)
        request.addValue(Constants.ParseParameterValues.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseParameterValues.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            
            func displayError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserData(false, NSError(domain: "getRequestStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            if let results = parsedResult as? [String:Any] {
                if let resultDictionary = results["results"] as? [[String:Any]] {
                    UsersData.dataArray = UsersData.CompileUsersData(resultDictionary)
                    completionHandlerForUserData(true, nil)
                }
                
            }
        }
        task.resume()
    }
    
    func getSingleUser(uniqueKey: String, completionHandlerForUpdate: @escaping (_ success: Bool,_ error: String?) -> Void) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(self.appDelegate.userID!)%22%7D"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func displayError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            if let results = parsedResult as? [String:Any] {
                if let resultDictionary = results["results"] as? [[String:Any]] {
                    if resultDictionary.count != 0 {
                        
                        var user = UsersData.CompileUsersData(resultDictionary)[0]
                        self.appDelegate.firstName = user.firstName
                        self.appDelegate.lastName = user.lastName
                        self.appDelegate.objectID = user.objectID
                        self.appDelegate.uniqueKey = user.uniqueKey
                        
                        completionHandlerForUpdate(true, nil)
                    } else {
                        print("As expected")
                        completionHandlerForUpdate(false, "No previous location found")
                        }
                    }
                }
            }
        task.resume()
    }
    
    
    func postStudentLocation(student: UsersData, location: String, completionHandlerForStudentPost: @escaping (_ success: Bool,_ objectID: String?, _ error: NSError?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.ParseParameterValues.application_id, forHTTPHeaderField: "X-Parse-Application-ID")
        request.addValue(Constants.ParseParameterValues.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\" : \"\(student.firstName)\", \"lastName\" : \"\(student.lastName)\", \"mapstring\" : \"\(location)\", \"mediaURL\" : \"\(student.mediaURL)\", \"latitude\" : \"\(student.lat)\", \"longitude\" : \"\(student.long)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as! URLRequest) {data, response, error in
            
            func handleError( error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForStudentPost(false, nil, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                handleError(error: "There was an error with the request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handleError(error: "Your request returned a status code other than 2xx! - POST")
                completionHandlerForStudentPost(false, nil, nil)
                return
            }
            
            guard data != nil else {
                handleError(error: "No data was returned by the request!")
                return
            }
            
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: \(data)")
                return
            }
            
            if let objectID = parsedResult["objectId"] as? String {
                self.appDelegate.objectID = objectID
                print(objectID)
                completionHandlerForStudentPost(true, objectID, nil)
            }
        }
        task.resume()
    }
    
    func updateExistingStudentInfo(student: UsersData, location: String, completionHandlerForPut: @escaping (_ success:Bool, _ error:NSError?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(student.objectID)"
        print(urlString)
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.ParseParameterValues.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseParameterValues.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.lat), \"longitude\": \(student.long)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as! URLRequest) { data, response, error in
            
            func handleError( error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPut(false, NSError(domain: "updateExistingStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                handleError(error: "There was an error with the request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handleError(error: "Your request returned a status code other than 2xx! - PUT")
                completionHandlerForPut(false, nil)
                return
        }
            guard data != nil else {
                handleError(error: "No data was returned by the request!")
                return
            }
            completionHandlerForPut(true, nil)
        }
        task.resume()
    }
    
    
    func logoutSession(controller: UIViewController) {
        
        var request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            
            func displayError(_ error: String) {
                print(error)
            }
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            print("Sucessfully logged out!")
        }
        task.resume()
    }
    
    class func sharedInstance() -> MasterNetwork {
        struct Singleton {
            static var sharedInstance = MasterNetwork()
        }
        return Singleton.sharedInstance
    }
    
    func buildParseURL(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.APIScheme
        components.host = Constants.Parse.APIHost
        components.path = Constants.Parse.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()

        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func ValidateURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
}
