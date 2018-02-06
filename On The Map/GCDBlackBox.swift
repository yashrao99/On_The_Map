//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Yash Rao on 1/26/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
