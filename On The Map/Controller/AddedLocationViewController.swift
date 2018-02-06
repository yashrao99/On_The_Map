//
//  AddedLocationViewController.swift
//  On The Map
//
//  Created by Yash Rao on 2/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class addedLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmLocation: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmLocation.backgroundColor = Constants.UI.LoginColorTop
        
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getAnnotation()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButton(_ sender: Any) {
        
        let userData = UsersData(dictionary: ["firstName" : appDelegate.firstName, "lastName" : appDelegate.lastName, "mediaURL": appDelegate.mediauRL, "latitude": appDelegate.latitude, "longitude": appDelegate.longitude, "objectId": appDelegate.objectID, "uniqueKey": appDelegate.uniqueKey])
        
        MasterNetwork.sharedInstance().updateExistingStudentInfo(student: userData!, location: appDelegate.mapString) { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    MasterNetwork.sharedInstance().segueToTabVC(self)
                } else {
                    MasterNetwork.sharedInstance().postStudentLocation(student: userData!, location: self.appDelegate.mapString, completionHandlerForStudentPost: {success, error in
                        if success {
                            MasterNetwork.sharedInstance().segueToTabVC(self)
                        } else {
                            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.postError)
                        }
                    })
                }
            }
        }
    }
    
    func getAnnotation () {
        let annotation = MKPointAnnotation()
        let latitude = self.appDelegate.latitude
        let longitude = self.appDelegate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        annotation.title = self.appDelegate.mapString
        performUIUpdatesOnMain {
            self.mapView.setRegion(region, animated: true)
            self.mapView.centerCoordinate = annotation.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
}
