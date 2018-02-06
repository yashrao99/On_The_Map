//
//  Constants.swift
//  On The Map
//
//  Created by Yash Rao on 1/21/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/"
    }
    
    struct ParseURLKeys {
        static let StudentLocation = "StudentLocation"
    }
    
    struct ParseOptionalParameters {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    struct ParseParameterValues {
        static let api_key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let application_id = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "udacity.com"
        static let APIPath = "/api/session"
        static let baseURL = "https://www.udacity.com/api/session"
    }
    
    
    struct UI {
        static let LoginColorTop = UIColor(red: 0.1, green: 0.65, blue: 1.0, alpha: 1.0)
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
    }
    
    
}
