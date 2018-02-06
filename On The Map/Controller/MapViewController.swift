//
//  MapViewController.swift
//  On The Map
//
//  Created by Yash Rao on 1/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locations : [String:AnyObject] = [:]
    var annotations = [MKPointAnnotation]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        MasterNetwork.sharedInstance().logoutSession(controller: self)
        MasterNetwork.sharedInstance().segueToLoginVC(self)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        MasterNetwork.sharedInstance().segueToSearchVC(self)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        loadMap()
    }
    
    func getAnnotationsForMap() {
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        
        for UserDict in UsersData.dataArray {
            let lat = UserDict.lat
            let long = UserDict.long
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = UserDict.firstName
            let last = UserDict.lastName
            let mediaURL = UserDict.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func loadMap() {
        MasterNetwork.sharedInstance().getRequestStudentLocationTest() {success, error in
            if success {
                performUIUpdatesOnMain {
                    self.getAnnotationsForMap()
                }
            } else {
                MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.GETError)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            self.mapView.delegate = self
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}


